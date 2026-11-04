//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
//Date        : Fri Oct 23 07:15:37 2026
//Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
//Command     : generate_target c6v.bd
//Design      : c6v
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "c6v,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=c6v,x_ipVersion=1.00.a,x_ipLanguage=VERILOG}" *) (* HW_HANDOFF = "c6v.hwdef" *) 
module c6v
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    IIC_1_scl_i,
    IIC_1_scl_o,
    IIC_1_scl_t,
    IIC_1_sda_i,
    IIC_1_sda_o,
    IIC_1_sda_t,
    audio_clk_10MHz,
    bclk,
    codec_address,
    hdmi_out_clk_n,
    hdmi_out_clk_p,
    hdmi_out_data_n,
    hdmi_out_data_p,
    lrclk,
    sdata_i,
    sdata_o,
    vid_data,
    vid_hsync,
    vid_iic_scl_i,
    vid_iic_scl_o,
    vid_iic_scl_t,
    vid_iic_sda_i,
    vid_iic_sda_o,
    vid_iic_sda_t,
    vid_pclk,
    vid_vsync,
    vid_xclk);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ADDR" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DDR, AXI_ARBITRATION_SCHEME TDM, BURST_LENGTH 8, CAN_DEBUG false, CAS_LATENCY 11, CAS_WRITE_LATENCY 11, CS_ENABLED true, DATA_MASK_ENABLED true, DATA_WIDTH 8, MEMORY_TYPE COMPONENTS, MEM_ADDR_MAP ROW_COLUMN_BANK, SLOT Single, TIMEPERIOD_PS 1250" *) inout [14:0]DDR_addr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR BA" *) inout [2:0]DDR_ba;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CAS_N" *) inout DDR_cas_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_N" *) inout DDR_ck_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CK_P" *) inout DDR_ck_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CKE" *) inout DDR_cke;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR CS_N" *) inout DDR_cs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DM" *) inout [3:0]DDR_dm;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQ" *) inout [31:0]DDR_dq;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_N" *) inout [3:0]DDR_dqs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR DQS_P" *) inout [3:0]DDR_dqs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR ODT" *) inout DDR_odt;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RAS_N" *) inout DDR_ras_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR RESET_N" *) inout DDR_reset_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ddrx:1.0 DDR WE_N" *) inout DDR_we_n;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRN" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME FIXED_IO, CAN_DEBUG false" *) inout FIXED_IO_ddr_vrn;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO DDR_VRP" *) inout FIXED_IO_ddr_vrp;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO MIO" *) inout [53:0]FIXED_IO_mio;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_CLK" *) inout FIXED_IO_ps_clk;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_PORB" *) inout FIXED_IO_ps_porb;
  (* X_INTERFACE_INFO = "xilinx.com:display_processing_system7:fixedio:1.0 FIXED_IO PS_SRSTB" *) inout FIXED_IO_ps_srstb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SCL_I" *) (* X_INTERFACE_MODE = "Master" *) input IIC_1_scl_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SCL_O" *) output IIC_1_scl_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SCL_T" *) output IIC_1_scl_t;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SDA_I" *) input IIC_1_sda_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SDA_O" *) output IIC_1_sda_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 IIC_1 SDA_T" *) output IIC_1_sda_t;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.AUDIO_CLK_10MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.AUDIO_CLK_10MHZ, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, FREQ_HZ 10000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output audio_clk_10MHz;
  output bclk;
  output [1:0]codec_address;
  output hdmi_out_clk_n;
  output hdmi_out_clk_p;
  output [2:0]hdmi_out_data_n;
  output [2:0]hdmi_out_data_p;
  output lrclk;
  input sdata_i;
  output [0:0]sdata_o;
  input [7:0]vid_data;
  input vid_hsync;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SCL_I" *) (* X_INTERFACE_MODE = "Master" *) input vid_iic_scl_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SCL_O" *) output vid_iic_scl_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SCL_T" *) output vid_iic_scl_t;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SDA_I" *) input vid_iic_sda_i;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SDA_O" *) output vid_iic_sda_o;
  (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 vid_iic SDA_T" *) output vid_iic_sda_t;
  input vid_pclk;
  input vid_vsync;
  output vid_xclk;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire IIC_1_scl_i;
  wire IIC_1_scl_o;
  wire IIC_1_scl_t;
  wire IIC_1_sda_i;
  wire IIC_1_sda_o;
  wire IIC_1_sda_t;
  wire audio_clk_10MHz;
  wire audio_mclk_locked;
  wire [31:0]axi_dma_M_AXI_MM2S_ARADDR;
  wire [1:0]axi_dma_M_AXI_MM2S_ARBURST;
  wire [3:0]axi_dma_M_AXI_MM2S_ARCACHE;
  wire [7:0]axi_dma_M_AXI_MM2S_ARLEN;
  wire [2:0]axi_dma_M_AXI_MM2S_ARPROT;
  wire axi_dma_M_AXI_MM2S_ARREADY;
  wire [2:0]axi_dma_M_AXI_MM2S_ARSIZE;
  wire axi_dma_M_AXI_MM2S_ARVALID;
  wire [63:0]axi_dma_M_AXI_MM2S_RDATA;
  wire axi_dma_M_AXI_MM2S_RLAST;
  wire axi_dma_M_AXI_MM2S_RREADY;
  wire [1:0]axi_dma_M_AXI_MM2S_RRESP;
  wire axi_dma_M_AXI_MM2S_RVALID;
  wire [63:0]axi_dma_m_axis_mm2s_tdata;
  wire [7:0]axi_dma_m_axis_mm2s_tkeep;
  wire axi_dma_m_axis_mm2s_tlast;
  wire axi_dma_m_axis_mm2s_tvalid;
  wire axi_dma_mm2s_introut;
  wire bclk;
  wire [31:0]build_id_constant_dout;
  wire [31:0]camera_hp1_smc_M00_AXI_AWADDR;
  wire [1:0]camera_hp1_smc_M00_AXI_AWBURST;
  wire [3:0]camera_hp1_smc_M00_AXI_AWCACHE;
  wire [3:0]camera_hp1_smc_M00_AXI_AWLEN;
  wire [1:0]camera_hp1_smc_M00_AXI_AWLOCK;
  wire [2:0]camera_hp1_smc_M00_AXI_AWPROT;
  wire [3:0]camera_hp1_smc_M00_AXI_AWQOS;
  wire camera_hp1_smc_M00_AXI_AWREADY;
  wire [2:0]camera_hp1_smc_M00_AXI_AWSIZE;
  wire camera_hp1_smc_M00_AXI_AWVALID;
  wire camera_hp1_smc_M00_AXI_BREADY;
  wire [1:0]camera_hp1_smc_M00_AXI_BRESP;
  wire camera_hp1_smc_M00_AXI_BVALID;
  wire [63:0]camera_hp1_smc_M00_AXI_WDATA;
  wire camera_hp1_smc_M00_AXI_WLAST;
  wire camera_hp1_smc_M00_AXI_WREADY;
  wire [7:0]camera_hp1_smc_M00_AXI_WSTRB;
  wire camera_hp1_smc_M00_AXI_WVALID;
  wire capture_control_abort_requested;
  wire capture_control_armed;
  wire capture_control_barrier_request;
  wire capture_control_capture_aresetn;
  wire [143:0]capture_control_cfg_frame_context;
  wire capture_control_owner_command_fault;
  wire capture_control_owner_cpu_claim;
  wire [31:0]capture_control_owner_cpu_epoch;
  wire [31:0]capture_control_owner_cpu_frame_id;
  wire capture_control_owner_cpu_release;
  wire [31:0]capture_lifecycle_available_epoch;
  wire [31:0]capture_lifecycle_available_frame_id;
  wire [31:0]capture_lifecycle_available_slot;
  wire capture_lifecycle_axis_enable;
  wire capture_lifecycle_capture_aresetn;
  wire capture_lifecycle_capture_source_fault;
  wire capture_lifecycle_claim_accepted;
  wire [31:0]capture_lifecycle_closed_frame_count;
  wire capture_lifecycle_cpu_available;
  wire capture_lifecycle_cpu_held;
  wire capture_lifecycle_epoch_sealed;
  wire [2:0]capture_lifecycle_fault_causes;
  wire capture_lifecycle_frame_credit_ready;
  wire [31:0]capture_lifecycle_granted_frames;
  wire capture_lifecycle_monitor_ready;
  wire capture_lifecycle_owner_drained;
  wire capture_lifecycle_owner_fault;
  wire [3:0]capture_lifecycle_owner_fault_causes;
  wire capture_lifecycle_release_accepted;
  wire [31:0]capture_lifecycle_released_frames;
  wire capture_lifecycle_source_closed;
  wire [1:0]capture_source_fault_fault_status;
  wire [31:0]capture_status_inputs_capture_epoch;
  wire [31:0]capture_write_pair_packet_completed_frames;
  wire [31:0]capture_write_pair_rgb_completed_frames;
  wire [31:0]capture_write_pair_status_completed_frames;
  wire capture_write_pair_status_fault;
  wire capture_write_pair_writes_drained;
  wire [1:0]codec_address;
  wire [8:0]command_read_address_gpio_gpio_io_o;
  wire [31:0]core_accepted_packet_count;
  wire [31:0]core_accepted_seq;
  wire [31:0]core_accepted_status;
  wire [31:0]core_asset_accepted_packet_count;
  wire [8:0]core_asset_error_flags;
  wire [31:0]core_asset_generation;
  wire [31:0]core_asset_rejected_packet_count;
  wire [31:0]core_asset_status;
  wire [31:0]core_debug_command_read_data_high;
  wire [31:0]core_debug_command_read_data_low;
  wire [31:0]core_framebuffer_status;
  wire [31:0]core_palette_accepted_packet_count;
  wire [8:0]core_palette_error_flags;
  wire [31:0]core_palette_generation;
  wire [31:0]core_palette_rejected_packet_count;
  wire [31:0]core_palette_status;
  wire [31:0]core_present_completed_count;
  wire [31:0]core_present_completed_seq;
  wire [31:0]core_rejected_packet_count;
  wire [31:0]core_render_completed_count;
  wire [31:0]core_render_completed_seq;
  wire [31:0]core_render_cycles;
  wire [31:0]core_render_maximum_cycles;
  wire [31:0]core_render_status;
  wire [31:0]core_render_trace_crc32;
  wire [31:0]core_render_write_count;
  wire [31:0]core_router_dropped_packet_count;
  wire core_s_axis_tready;
  wire [31:0]core_tilemap_accepted_packet_count;
  wire [8:0]core_tilemap_error_flags;
  wire [31:0]core_tilemap_generation;
  wire [31:0]core_tilemap_rejected_packet_count;
  wire [31:0]core_tilemap_status;
  wire [31:0]core_unsupported_packet_count;
  wire [31:0]core_upload_byte_count;
  wire [31:0]core_upload_crc32;
  wire [5:0]core_upload_error_flags;
  wire [31:0]core_upload_packet_count;
  wire [23:0]core_vid_data;
  wire core_vid_de;
  wire core_vid_hsync;
  wire core_vid_vsync;
  wire [23:0]demosaic_m_axis_video_TDATA;
  wire [2:0]demosaic_m_axis_video_TKEEP;
  wire [0:0]demosaic_m_axis_video_TLAST;
  wire demosaic_m_axis_video_TREADY;
  wire [0:0]demosaic_m_axis_video_TUSER;
  wire demosaic_m_axis_video_TVALID;
  wire [31:0]dual_mask_capture_M_PACKET_TDATA;
  wire [3:0]dual_mask_capture_M_PACKET_TKEEP;
  wire dual_mask_capture_M_PACKET_TLAST;
  wire dual_mask_capture_M_PACKET_TREADY;
  wire dual_mask_capture_M_PACKET_TVALID;
  wire [23:0]dual_mask_capture_M_RGB_TDATA;
  wire [2:0]dual_mask_capture_M_RGB_TKEEP;
  wire dual_mask_capture_M_RGB_TLAST;
  wire dual_mask_capture_M_RGB_TREADY;
  wire dual_mask_capture_M_RGB_TUSER;
  wire dual_mask_capture_M_RGB_TVALID;
  wire dual_mask_capture_frame_credit_request;
  wire dual_mask_capture_frame_fault;
  wire dual_mask_capture_pipeline_drained;
  wire [31:0]frame_dma_M_AXI_S2MM_AWADDR;
  wire [1:0]frame_dma_M_AXI_S2MM_AWBURST;
  wire [3:0]frame_dma_M_AXI_S2MM_AWCACHE;
  wire [7:0]frame_dma_M_AXI_S2MM_AWLEN;
  wire [2:0]frame_dma_M_AXI_S2MM_AWPROT;
  wire frame_dma_M_AXI_S2MM_AWREADY;
  wire [2:0]frame_dma_M_AXI_S2MM_AWSIZE;
  wire frame_dma_M_AXI_S2MM_AWVALID;
  wire frame_dma_M_AXI_S2MM_BREADY;
  wire [1:0]frame_dma_M_AXI_S2MM_BRESP;
  wire frame_dma_M_AXI_S2MM_BVALID;
  wire [63:0]frame_dma_M_AXI_S2MM_WDATA;
  wire frame_dma_M_AXI_S2MM_WLAST;
  wire frame_dma_M_AXI_S2MM_WREADY;
  wire [7:0]frame_dma_M_AXI_S2MM_WSTRB;
  wire frame_dma_M_AXI_S2MM_WVALID;
  wire frame_dma_s2mm_introut;
  wire [9:0]gp0_smc_M00_AXI_ARADDR;
  wire gp0_smc_M00_AXI_ARREADY;
  wire gp0_smc_M00_AXI_ARVALID;
  wire [9:0]gp0_smc_M00_AXI_AWADDR;
  wire gp0_smc_M00_AXI_AWREADY;
  wire gp0_smc_M00_AXI_AWVALID;
  wire gp0_smc_M00_AXI_BREADY;
  wire [1:0]gp0_smc_M00_AXI_BRESP;
  wire gp0_smc_M00_AXI_BVALID;
  wire [31:0]gp0_smc_M00_AXI_RDATA;
  wire gp0_smc_M00_AXI_RREADY;
  wire [1:0]gp0_smc_M00_AXI_RRESP;
  wire gp0_smc_M00_AXI_RVALID;
  wire [31:0]gp0_smc_M00_AXI_WDATA;
  wire gp0_smc_M00_AXI_WREADY;
  wire gp0_smc_M00_AXI_WVALID;
  wire [8:0]gp0_smc_M01_AXI_ARADDR;
  wire gp0_smc_M01_AXI_ARREADY;
  wire gp0_smc_M01_AXI_ARVALID;
  wire [8:0]gp0_smc_M01_AXI_AWADDR;
  wire gp0_smc_M01_AXI_AWREADY;
  wire gp0_smc_M01_AXI_AWVALID;
  wire gp0_smc_M01_AXI_BREADY;
  wire [1:0]gp0_smc_M01_AXI_BRESP;
  wire gp0_smc_M01_AXI_BVALID;
  wire [31:0]gp0_smc_M01_AXI_RDATA;
  wire gp0_smc_M01_AXI_RREADY;
  wire [1:0]gp0_smc_M01_AXI_RRESP;
  wire gp0_smc_M01_AXI_RVALID;
  wire [31:0]gp0_smc_M01_AXI_WDATA;
  wire gp0_smc_M01_AXI_WREADY;
  wire [3:0]gp0_smc_M01_AXI_WSTRB;
  wire gp0_smc_M01_AXI_WVALID;
  wire [8:0]gp0_smc_M02_AXI_ARADDR;
  wire gp0_smc_M02_AXI_ARREADY;
  wire gp0_smc_M02_AXI_ARVALID;
  wire [8:0]gp0_smc_M02_AXI_AWADDR;
  wire gp0_smc_M02_AXI_AWREADY;
  wire gp0_smc_M02_AXI_AWVALID;
  wire gp0_smc_M02_AXI_BREADY;
  wire [1:0]gp0_smc_M02_AXI_BRESP;
  wire gp0_smc_M02_AXI_BVALID;
  wire [31:0]gp0_smc_M02_AXI_RDATA;
  wire gp0_smc_M02_AXI_RREADY;
  wire [1:0]gp0_smc_M02_AXI_RRESP;
  wire gp0_smc_M02_AXI_RVALID;
  wire [31:0]gp0_smc_M02_AXI_WDATA;
  wire gp0_smc_M02_AXI_WREADY;
  wire [3:0]gp0_smc_M02_AXI_WSTRB;
  wire gp0_smc_M02_AXI_WVALID;
  wire [8:0]gp0_smc_M03_AXI_ARADDR;
  wire gp0_smc_M03_AXI_ARREADY;
  wire gp0_smc_M03_AXI_ARVALID;
  wire [8:0]gp0_smc_M03_AXI_AWADDR;
  wire gp0_smc_M03_AXI_AWREADY;
  wire gp0_smc_M03_AXI_AWVALID;
  wire gp0_smc_M03_AXI_BREADY;
  wire [1:0]gp0_smc_M03_AXI_BRESP;
  wire gp0_smc_M03_AXI_BVALID;
  wire [31:0]gp0_smc_M03_AXI_RDATA;
  wire gp0_smc_M03_AXI_RREADY;
  wire [1:0]gp0_smc_M03_AXI_RRESP;
  wire gp0_smc_M03_AXI_RVALID;
  wire [31:0]gp0_smc_M03_AXI_WDATA;
  wire gp0_smc_M03_AXI_WREADY;
  wire [3:0]gp0_smc_M03_AXI_WSTRB;
  wire gp0_smc_M03_AXI_WVALID;
  wire [8:0]gp0_smc_M04_AXI_ARADDR;
  wire gp0_smc_M04_AXI_ARREADY;
  wire gp0_smc_M04_AXI_ARVALID;
  wire [8:0]gp0_smc_M04_AXI_AWADDR;
  wire gp0_smc_M04_AXI_AWREADY;
  wire gp0_smc_M04_AXI_AWVALID;
  wire gp0_smc_M04_AXI_BREADY;
  wire [1:0]gp0_smc_M04_AXI_BRESP;
  wire gp0_smc_M04_AXI_BVALID;
  wire [31:0]gp0_smc_M04_AXI_RDATA;
  wire gp0_smc_M04_AXI_RREADY;
  wire [1:0]gp0_smc_M04_AXI_RRESP;
  wire gp0_smc_M04_AXI_RVALID;
  wire [31:0]gp0_smc_M04_AXI_WDATA;
  wire gp0_smc_M04_AXI_WREADY;
  wire [3:0]gp0_smc_M04_AXI_WSTRB;
  wire gp0_smc_M04_AXI_WVALID;
  wire [8:0]gp0_smc_M05_AXI_ARADDR;
  wire gp0_smc_M05_AXI_ARREADY;
  wire gp0_smc_M05_AXI_ARVALID;
  wire [8:0]gp0_smc_M05_AXI_AWADDR;
  wire gp0_smc_M05_AXI_AWREADY;
  wire gp0_smc_M05_AXI_AWVALID;
  wire gp0_smc_M05_AXI_BREADY;
  wire [1:0]gp0_smc_M05_AXI_BRESP;
  wire gp0_smc_M05_AXI_BVALID;
  wire [31:0]gp0_smc_M05_AXI_RDATA;
  wire gp0_smc_M05_AXI_RREADY;
  wire [1:0]gp0_smc_M05_AXI_RRESP;
  wire gp0_smc_M05_AXI_RVALID;
  wire [31:0]gp0_smc_M05_AXI_WDATA;
  wire gp0_smc_M05_AXI_WREADY;
  wire [3:0]gp0_smc_M05_AXI_WSTRB;
  wire gp0_smc_M05_AXI_WVALID;
  wire [8:0]gp0_smc_M06_AXI_ARADDR;
  wire gp0_smc_M06_AXI_ARREADY;
  wire gp0_smc_M06_AXI_ARVALID;
  wire [8:0]gp0_smc_M06_AXI_AWADDR;
  wire gp0_smc_M06_AXI_AWREADY;
  wire gp0_smc_M06_AXI_AWVALID;
  wire gp0_smc_M06_AXI_BREADY;
  wire [1:0]gp0_smc_M06_AXI_BRESP;
  wire gp0_smc_M06_AXI_BVALID;
  wire [31:0]gp0_smc_M06_AXI_RDATA;
  wire gp0_smc_M06_AXI_RREADY;
  wire [1:0]gp0_smc_M06_AXI_RRESP;
  wire gp0_smc_M06_AXI_RVALID;
  wire [31:0]gp0_smc_M06_AXI_WDATA;
  wire gp0_smc_M06_AXI_WREADY;
  wire [3:0]gp0_smc_M06_AXI_WSTRB;
  wire gp0_smc_M06_AXI_WVALID;
  wire [8:0]gp0_smc_M07_AXI_ARADDR;
  wire gp0_smc_M07_AXI_ARREADY;
  wire gp0_smc_M07_AXI_ARVALID;
  wire [8:0]gp0_smc_M07_AXI_AWADDR;
  wire gp0_smc_M07_AXI_AWREADY;
  wire gp0_smc_M07_AXI_AWVALID;
  wire gp0_smc_M07_AXI_BREADY;
  wire [1:0]gp0_smc_M07_AXI_BRESP;
  wire gp0_smc_M07_AXI_BVALID;
  wire [31:0]gp0_smc_M07_AXI_RDATA;
  wire gp0_smc_M07_AXI_RREADY;
  wire [1:0]gp0_smc_M07_AXI_RRESP;
  wire gp0_smc_M07_AXI_RVALID;
  wire [31:0]gp0_smc_M07_AXI_WDATA;
  wire gp0_smc_M07_AXI_WREADY;
  wire [3:0]gp0_smc_M07_AXI_WSTRB;
  wire gp0_smc_M07_AXI_WVALID;
  wire [8:0]gp0_smc_M08_AXI_ARADDR;
  wire gp0_smc_M08_AXI_ARREADY;
  wire gp0_smc_M08_AXI_ARVALID;
  wire [8:0]gp0_smc_M08_AXI_AWADDR;
  wire gp0_smc_M08_AXI_AWREADY;
  wire gp0_smc_M08_AXI_AWVALID;
  wire gp0_smc_M08_AXI_BREADY;
  wire [1:0]gp0_smc_M08_AXI_BRESP;
  wire gp0_smc_M08_AXI_BVALID;
  wire [31:0]gp0_smc_M08_AXI_RDATA;
  wire gp0_smc_M08_AXI_RREADY;
  wire [1:0]gp0_smc_M08_AXI_RRESP;
  wire gp0_smc_M08_AXI_RVALID;
  wire [31:0]gp0_smc_M08_AXI_WDATA;
  wire gp0_smc_M08_AXI_WREADY;
  wire [3:0]gp0_smc_M08_AXI_WSTRB;
  wire gp0_smc_M08_AXI_WVALID;
  wire [8:0]gp0_smc_M09_AXI_ARADDR;
  wire gp0_smc_M09_AXI_ARREADY;
  wire gp0_smc_M09_AXI_ARVALID;
  wire [8:0]gp0_smc_M09_AXI_AWADDR;
  wire gp0_smc_M09_AXI_AWREADY;
  wire gp0_smc_M09_AXI_AWVALID;
  wire gp0_smc_M09_AXI_BREADY;
  wire [1:0]gp0_smc_M09_AXI_BRESP;
  wire gp0_smc_M09_AXI_BVALID;
  wire [31:0]gp0_smc_M09_AXI_RDATA;
  wire gp0_smc_M09_AXI_RREADY;
  wire [1:0]gp0_smc_M09_AXI_RRESP;
  wire gp0_smc_M09_AXI_RVALID;
  wire [31:0]gp0_smc_M09_AXI_WDATA;
  wire gp0_smc_M09_AXI_WREADY;
  wire [3:0]gp0_smc_M09_AXI_WSTRB;
  wire gp0_smc_M09_AXI_WVALID;
  wire [8:0]gp0_smc_M10_AXI_ARADDR;
  wire gp0_smc_M10_AXI_ARREADY;
  wire gp0_smc_M10_AXI_ARVALID;
  wire [8:0]gp0_smc_M10_AXI_AWADDR;
  wire gp0_smc_M10_AXI_AWREADY;
  wire gp0_smc_M10_AXI_AWVALID;
  wire gp0_smc_M10_AXI_BREADY;
  wire [1:0]gp0_smc_M10_AXI_BRESP;
  wire gp0_smc_M10_AXI_BVALID;
  wire [31:0]gp0_smc_M10_AXI_RDATA;
  wire gp0_smc_M10_AXI_RREADY;
  wire [1:0]gp0_smc_M10_AXI_RRESP;
  wire gp0_smc_M10_AXI_RVALID;
  wire [31:0]gp0_smc_M10_AXI_WDATA;
  wire gp0_smc_M10_AXI_WREADY;
  wire [3:0]gp0_smc_M10_AXI_WSTRB;
  wire gp0_smc_M10_AXI_WVALID;
  wire [8:0]gp0_smc_M11_AXI_ARADDR;
  wire gp0_smc_M11_AXI_ARREADY;
  wire gp0_smc_M11_AXI_ARVALID;
  wire [8:0]gp0_smc_M11_AXI_AWADDR;
  wire gp0_smc_M11_AXI_AWREADY;
  wire gp0_smc_M11_AXI_AWVALID;
  wire gp0_smc_M11_AXI_BREADY;
  wire [1:0]gp0_smc_M11_AXI_BRESP;
  wire gp0_smc_M11_AXI_BVALID;
  wire [31:0]gp0_smc_M11_AXI_RDATA;
  wire gp0_smc_M11_AXI_RREADY;
  wire [1:0]gp0_smc_M11_AXI_RRESP;
  wire gp0_smc_M11_AXI_RVALID;
  wire [31:0]gp0_smc_M11_AXI_WDATA;
  wire gp0_smc_M11_AXI_WREADY;
  wire [3:0]gp0_smc_M11_AXI_WSTRB;
  wire gp0_smc_M11_AXI_WVALID;
  wire [8:0]gp0_smc_M12_AXI_ARADDR;
  wire gp0_smc_M12_AXI_ARREADY;
  wire gp0_smc_M12_AXI_ARVALID;
  wire [8:0]gp0_smc_M12_AXI_AWADDR;
  wire gp0_smc_M12_AXI_AWREADY;
  wire gp0_smc_M12_AXI_AWVALID;
  wire gp0_smc_M12_AXI_BREADY;
  wire [1:0]gp0_smc_M12_AXI_BRESP;
  wire gp0_smc_M12_AXI_BVALID;
  wire [31:0]gp0_smc_M12_AXI_RDATA;
  wire gp0_smc_M12_AXI_RREADY;
  wire [1:0]gp0_smc_M12_AXI_RRESP;
  wire gp0_smc_M12_AXI_RVALID;
  wire [31:0]gp0_smc_M12_AXI_WDATA;
  wire gp0_smc_M12_AXI_WREADY;
  wire [3:0]gp0_smc_M12_AXI_WSTRB;
  wire gp0_smc_M12_AXI_WVALID;
  wire [8:0]gp0_smc_M13_AXI_ARADDR;
  wire gp0_smc_M13_AXI_ARREADY;
  wire gp0_smc_M13_AXI_ARVALID;
  wire [8:0]gp0_smc_M13_AXI_AWADDR;
  wire gp0_smc_M13_AXI_AWREADY;
  wire gp0_smc_M13_AXI_AWVALID;
  wire gp0_smc_M13_AXI_BREADY;
  wire [1:0]gp0_smc_M13_AXI_BRESP;
  wire gp0_smc_M13_AXI_BVALID;
  wire [31:0]gp0_smc_M13_AXI_RDATA;
  wire gp0_smc_M13_AXI_RREADY;
  wire [1:0]gp0_smc_M13_AXI_RRESP;
  wire gp0_smc_M13_AXI_RVALID;
  wire [31:0]gp0_smc_M13_AXI_WDATA;
  wire gp0_smc_M13_AXI_WREADY;
  wire [3:0]gp0_smc_M13_AXI_WSTRB;
  wire gp0_smc_M13_AXI_WVALID;
  wire [8:0]gp0_smc_M14_AXI_ARADDR;
  wire gp0_smc_M14_AXI_ARREADY;
  wire gp0_smc_M14_AXI_ARVALID;
  wire [8:0]gp0_smc_M14_AXI_AWADDR;
  wire gp0_smc_M14_AXI_AWREADY;
  wire gp0_smc_M14_AXI_AWVALID;
  wire gp0_smc_M14_AXI_BREADY;
  wire [1:0]gp0_smc_M14_AXI_BRESP;
  wire gp0_smc_M14_AXI_BVALID;
  wire [31:0]gp0_smc_M14_AXI_RDATA;
  wire gp0_smc_M14_AXI_RREADY;
  wire [1:0]gp0_smc_M14_AXI_RRESP;
  wire gp0_smc_M14_AXI_RVALID;
  wire [31:0]gp0_smc_M14_AXI_WDATA;
  wire gp0_smc_M14_AXI_WREADY;
  wire [3:0]gp0_smc_M14_AXI_WSTRB;
  wire gp0_smc_M14_AXI_WVALID;
  wire [8:0]gp0_smc_M15_AXI_ARADDR;
  wire gp0_smc_M15_AXI_ARREADY;
  wire gp0_smc_M15_AXI_ARVALID;
  wire [8:0]gp0_smc_M15_AXI_AWADDR;
  wire gp0_smc_M15_AXI_AWREADY;
  wire gp0_smc_M15_AXI_AWVALID;
  wire gp0_smc_M15_AXI_BREADY;
  wire [1:0]gp0_smc_M15_AXI_BRESP;
  wire gp0_smc_M15_AXI_BVALID;
  wire [31:0]gp0_smc_M15_AXI_RDATA;
  wire gp0_smc_M15_AXI_RREADY;
  wire [1:0]gp0_smc_M15_AXI_RRESP;
  wire gp0_smc_M15_AXI_RVALID;
  wire [31:0]gp0_smc_M15_AXI_WDATA;
  wire gp0_smc_M15_AXI_WREADY;
  wire [3:0]gp0_smc_M15_AXI_WSTRB;
  wire gp0_smc_M15_AXI_WVALID;
  wire [8:0]gp0_smc_M16_AXI_ARADDR;
  wire gp0_smc_M16_AXI_ARREADY;
  wire gp0_smc_M16_AXI_ARVALID;
  wire [8:0]gp0_smc_M16_AXI_AWADDR;
  wire gp0_smc_M16_AXI_AWREADY;
  wire gp0_smc_M16_AXI_AWVALID;
  wire gp0_smc_M16_AXI_BREADY;
  wire [1:0]gp0_smc_M16_AXI_BRESP;
  wire gp0_smc_M16_AXI_BVALID;
  wire [31:0]gp0_smc_M16_AXI_RDATA;
  wire gp0_smc_M16_AXI_RREADY;
  wire [1:0]gp0_smc_M16_AXI_RRESP;
  wire gp0_smc_M16_AXI_RVALID;
  wire [31:0]gp0_smc_M16_AXI_WDATA;
  wire gp0_smc_M16_AXI_WREADY;
  wire [3:0]gp0_smc_M16_AXI_WSTRB;
  wire gp0_smc_M16_AXI_WVALID;
  wire [8:0]gp0_smc_M17_AXI_ARADDR;
  wire gp0_smc_M17_AXI_ARREADY;
  wire gp0_smc_M17_AXI_ARVALID;
  wire [8:0]gp0_smc_M17_AXI_AWADDR;
  wire gp0_smc_M17_AXI_AWREADY;
  wire gp0_smc_M17_AXI_AWVALID;
  wire gp0_smc_M17_AXI_BREADY;
  wire [1:0]gp0_smc_M17_AXI_BRESP;
  wire gp0_smc_M17_AXI_BVALID;
  wire [31:0]gp0_smc_M17_AXI_RDATA;
  wire gp0_smc_M17_AXI_RREADY;
  wire [1:0]gp0_smc_M17_AXI_RRESP;
  wire gp0_smc_M17_AXI_RVALID;
  wire [31:0]gp0_smc_M17_AXI_WDATA;
  wire gp0_smc_M17_AXI_WREADY;
  wire [3:0]gp0_smc_M17_AXI_WSTRB;
  wire gp0_smc_M17_AXI_WVALID;
  wire [8:0]gp0_smc_M18_AXI_ARADDR;
  wire gp0_smc_M18_AXI_ARREADY;
  wire gp0_smc_M18_AXI_ARVALID;
  wire [8:0]gp0_smc_M18_AXI_AWADDR;
  wire gp0_smc_M18_AXI_AWREADY;
  wire gp0_smc_M18_AXI_AWVALID;
  wire gp0_smc_M18_AXI_BREADY;
  wire [1:0]gp0_smc_M18_AXI_BRESP;
  wire gp0_smc_M18_AXI_BVALID;
  wire [31:0]gp0_smc_M18_AXI_RDATA;
  wire gp0_smc_M18_AXI_RREADY;
  wire [1:0]gp0_smc_M18_AXI_RRESP;
  wire gp0_smc_M18_AXI_RVALID;
  wire [31:0]gp0_smc_M18_AXI_WDATA;
  wire gp0_smc_M18_AXI_WREADY;
  wire [3:0]gp0_smc_M18_AXI_WSTRB;
  wire gp0_smc_M18_AXI_WVALID;
  wire [8:0]gp0_smc_M19_AXI_ARADDR;
  wire gp0_smc_M19_AXI_ARREADY;
  wire gp0_smc_M19_AXI_ARVALID;
  wire [8:0]gp0_smc_M19_AXI_AWADDR;
  wire gp0_smc_M19_AXI_AWREADY;
  wire gp0_smc_M19_AXI_AWVALID;
  wire gp0_smc_M19_AXI_BREADY;
  wire [1:0]gp0_smc_M19_AXI_BRESP;
  wire gp0_smc_M19_AXI_BVALID;
  wire [31:0]gp0_smc_M19_AXI_RDATA;
  wire gp0_smc_M19_AXI_RREADY;
  wire [1:0]gp0_smc_M19_AXI_RRESP;
  wire gp0_smc_M19_AXI_RVALID;
  wire [31:0]gp0_smc_M19_AXI_WDATA;
  wire gp0_smc_M19_AXI_WREADY;
  wire [3:0]gp0_smc_M19_AXI_WSTRB;
  wire gp0_smc_M19_AXI_WVALID;
  wire [8:0]gp0_smc_M20_AXI_ARADDR;
  wire gp0_smc_M20_AXI_ARREADY;
  wire gp0_smc_M20_AXI_ARVALID;
  wire [8:0]gp0_smc_M20_AXI_AWADDR;
  wire gp0_smc_M20_AXI_AWREADY;
  wire gp0_smc_M20_AXI_AWVALID;
  wire gp0_smc_M20_AXI_BREADY;
  wire [1:0]gp0_smc_M20_AXI_BRESP;
  wire gp0_smc_M20_AXI_BVALID;
  wire [31:0]gp0_smc_M20_AXI_RDATA;
  wire gp0_smc_M20_AXI_RREADY;
  wire [1:0]gp0_smc_M20_AXI_RRESP;
  wire gp0_smc_M20_AXI_RVALID;
  wire [31:0]gp0_smc_M20_AXI_WDATA;
  wire gp0_smc_M20_AXI_WREADY;
  wire [3:0]gp0_smc_M20_AXI_WSTRB;
  wire gp0_smc_M20_AXI_WVALID;
  wire [8:0]gp0_smc_M21_AXI_ARADDR;
  wire gp0_smc_M21_AXI_ARREADY;
  wire gp0_smc_M21_AXI_ARVALID;
  wire [8:0]gp0_smc_M21_AXI_AWADDR;
  wire gp0_smc_M21_AXI_AWREADY;
  wire gp0_smc_M21_AXI_AWVALID;
  wire gp0_smc_M21_AXI_BREADY;
  wire [1:0]gp0_smc_M21_AXI_BRESP;
  wire gp0_smc_M21_AXI_BVALID;
  wire [31:0]gp0_smc_M21_AXI_RDATA;
  wire gp0_smc_M21_AXI_RREADY;
  wire [1:0]gp0_smc_M21_AXI_RRESP;
  wire gp0_smc_M21_AXI_RVALID;
  wire [31:0]gp0_smc_M21_AXI_WDATA;
  wire gp0_smc_M21_AXI_WREADY;
  wire [3:0]gp0_smc_M21_AXI_WSTRB;
  wire gp0_smc_M21_AXI_WVALID;
  wire [8:0]gp0_smc_M22_AXI_ARADDR;
  wire gp0_smc_M22_AXI_ARREADY;
  wire gp0_smc_M22_AXI_ARVALID;
  wire [8:0]gp0_smc_M22_AXI_AWADDR;
  wire gp0_smc_M22_AXI_AWREADY;
  wire gp0_smc_M22_AXI_AWVALID;
  wire gp0_smc_M22_AXI_BREADY;
  wire [1:0]gp0_smc_M22_AXI_BRESP;
  wire gp0_smc_M22_AXI_BVALID;
  wire [31:0]gp0_smc_M22_AXI_RDATA;
  wire gp0_smc_M22_AXI_RREADY;
  wire [1:0]gp0_smc_M22_AXI_RRESP;
  wire gp0_smc_M22_AXI_RVALID;
  wire [31:0]gp0_smc_M22_AXI_WDATA;
  wire gp0_smc_M22_AXI_WREADY;
  wire [3:0]gp0_smc_M22_AXI_WSTRB;
  wire gp0_smc_M22_AXI_WVALID;
  wire [8:0]gp0_smc_M23_AXI_ARADDR;
  wire gp0_smc_M23_AXI_ARREADY;
  wire gp0_smc_M23_AXI_ARVALID;
  wire [8:0]gp0_smc_M23_AXI_AWADDR;
  wire gp0_smc_M23_AXI_AWREADY;
  wire gp0_smc_M23_AXI_AWVALID;
  wire gp0_smc_M23_AXI_BREADY;
  wire [1:0]gp0_smc_M23_AXI_BRESP;
  wire gp0_smc_M23_AXI_BVALID;
  wire [31:0]gp0_smc_M23_AXI_RDATA;
  wire gp0_smc_M23_AXI_RREADY;
  wire [1:0]gp0_smc_M23_AXI_RRESP;
  wire gp0_smc_M23_AXI_RVALID;
  wire [31:0]gp0_smc_M23_AXI_WDATA;
  wire gp0_smc_M23_AXI_WREADY;
  wire [3:0]gp0_smc_M23_AXI_WSTRB;
  wire gp0_smc_M23_AXI_WVALID;
  wire [9:0]gp0_smc_M24_AXI_ARADDR;
  wire gp0_smc_M24_AXI_ARREADY;
  wire gp0_smc_M24_AXI_ARVALID;
  wire [9:0]gp0_smc_M24_AXI_AWADDR;
  wire gp0_smc_M24_AXI_AWREADY;
  wire gp0_smc_M24_AXI_AWVALID;
  wire gp0_smc_M24_AXI_BREADY;
  wire [1:0]gp0_smc_M24_AXI_BRESP;
  wire gp0_smc_M24_AXI_BVALID;
  wire [31:0]gp0_smc_M24_AXI_RDATA;
  wire gp0_smc_M24_AXI_RREADY;
  wire [1:0]gp0_smc_M24_AXI_RRESP;
  wire gp0_smc_M24_AXI_RVALID;
  wire [31:0]gp0_smc_M24_AXI_WDATA;
  wire gp0_smc_M24_AXI_WREADY;
  wire gp0_smc_M24_AXI_WVALID;
  wire [8:0]gp0_smc_M25_AXI_ARADDR;
  wire gp0_smc_M25_AXI_ARREADY;
  wire gp0_smc_M25_AXI_ARVALID;
  wire [8:0]gp0_smc_M25_AXI_AWADDR;
  wire gp0_smc_M25_AXI_AWREADY;
  wire gp0_smc_M25_AXI_AWVALID;
  wire gp0_smc_M25_AXI_BREADY;
  wire [1:0]gp0_smc_M25_AXI_BRESP;
  wire gp0_smc_M25_AXI_BVALID;
  wire [31:0]gp0_smc_M25_AXI_RDATA;
  wire gp0_smc_M25_AXI_RREADY;
  wire [1:0]gp0_smc_M25_AXI_RRESP;
  wire gp0_smc_M25_AXI_RVALID;
  wire [31:0]gp0_smc_M25_AXI_WDATA;
  wire gp0_smc_M25_AXI_WREADY;
  wire [3:0]gp0_smc_M25_AXI_WSTRB;
  wire gp0_smc_M25_AXI_WVALID;
  wire [8:0]gp0_smc_M26_AXI_ARADDR;
  wire gp0_smc_M26_AXI_ARREADY;
  wire gp0_smc_M26_AXI_ARVALID;
  wire [8:0]gp0_smc_M26_AXI_AWADDR;
  wire gp0_smc_M26_AXI_AWREADY;
  wire gp0_smc_M26_AXI_AWVALID;
  wire gp0_smc_M26_AXI_BREADY;
  wire [1:0]gp0_smc_M26_AXI_BRESP;
  wire gp0_smc_M26_AXI_BVALID;
  wire [31:0]gp0_smc_M26_AXI_RDATA;
  wire gp0_smc_M26_AXI_RREADY;
  wire [1:0]gp0_smc_M26_AXI_RRESP;
  wire gp0_smc_M26_AXI_RVALID;
  wire [31:0]gp0_smc_M26_AXI_WDATA;
  wire gp0_smc_M26_AXI_WREADY;
  wire [3:0]gp0_smc_M26_AXI_WSTRB;
  wire gp0_smc_M26_AXI_WVALID;
  wire [8:0]gp0_smc_M27_AXI_ARADDR;
  wire gp0_smc_M27_AXI_ARREADY;
  wire gp0_smc_M27_AXI_ARVALID;
  wire [8:0]gp0_smc_M27_AXI_AWADDR;
  wire gp0_smc_M27_AXI_AWREADY;
  wire gp0_smc_M27_AXI_AWVALID;
  wire gp0_smc_M27_AXI_BREADY;
  wire [1:0]gp0_smc_M27_AXI_BRESP;
  wire gp0_smc_M27_AXI_BVALID;
  wire [31:0]gp0_smc_M27_AXI_RDATA;
  wire gp0_smc_M27_AXI_RREADY;
  wire [1:0]gp0_smc_M27_AXI_RRESP;
  wire gp0_smc_M27_AXI_RVALID;
  wire [31:0]gp0_smc_M27_AXI_WDATA;
  wire gp0_smc_M27_AXI_WREADY;
  wire [3:0]gp0_smc_M27_AXI_WSTRB;
  wire gp0_smc_M27_AXI_WVALID;
  wire [8:0]gp0_smc_M28_AXI_ARADDR;
  wire gp0_smc_M28_AXI_ARREADY;
  wire gp0_smc_M28_AXI_ARVALID;
  wire [8:0]gp0_smc_M28_AXI_AWADDR;
  wire gp0_smc_M28_AXI_AWREADY;
  wire gp0_smc_M28_AXI_AWVALID;
  wire gp0_smc_M28_AXI_BREADY;
  wire [1:0]gp0_smc_M28_AXI_BRESP;
  wire gp0_smc_M28_AXI_BVALID;
  wire [31:0]gp0_smc_M28_AXI_RDATA;
  wire gp0_smc_M28_AXI_RREADY;
  wire [1:0]gp0_smc_M28_AXI_RRESP;
  wire gp0_smc_M28_AXI_RVALID;
  wire [31:0]gp0_smc_M28_AXI_WDATA;
  wire gp0_smc_M28_AXI_WREADY;
  wire [3:0]gp0_smc_M28_AXI_WSTRB;
  wire gp0_smc_M28_AXI_WVALID;
  wire [31:0]gp0_smc_M29_AXI_ARADDR;
  wire [1:0]gp0_smc_M29_AXI_ARBURST;
  wire [3:0]gp0_smc_M29_AXI_ARCACHE;
  wire [2:0]gp0_smc_M29_AXI_ARID;
  wire [7:0]gp0_smc_M29_AXI_ARLEN;
  wire [0:0]gp0_smc_M29_AXI_ARLOCK;
  wire [2:0]gp0_smc_M29_AXI_ARPROT;
  wire [3:0]gp0_smc_M29_AXI_ARQOS;
  wire gp0_smc_M29_AXI_ARREADY;
  wire [2:0]gp0_smc_M29_AXI_ARSIZE;
  wire [113:0]gp0_smc_M29_AXI_ARUSER;
  wire gp0_smc_M29_AXI_ARVALID;
  wire [31:0]gp0_smc_M29_AXI_AWADDR;
  wire [1:0]gp0_smc_M29_AXI_AWBURST;
  wire [3:0]gp0_smc_M29_AXI_AWCACHE;
  wire [2:0]gp0_smc_M29_AXI_AWID;
  wire [7:0]gp0_smc_M29_AXI_AWLEN;
  wire [0:0]gp0_smc_M29_AXI_AWLOCK;
  wire [2:0]gp0_smc_M29_AXI_AWPROT;
  wire [3:0]gp0_smc_M29_AXI_AWQOS;
  wire gp0_smc_M29_AXI_AWREADY;
  wire [2:0]gp0_smc_M29_AXI_AWSIZE;
  wire [113:0]gp0_smc_M29_AXI_AWUSER;
  wire gp0_smc_M29_AXI_AWVALID;
  wire [2:0]gp0_smc_M29_AXI_BID;
  wire gp0_smc_M29_AXI_BREADY;
  wire [1:0]gp0_smc_M29_AXI_BRESP;
  wire gp0_smc_M29_AXI_BVALID;
  wire [31:0]gp0_smc_M29_AXI_RDATA;
  wire [2:0]gp0_smc_M29_AXI_RID;
  wire gp0_smc_M29_AXI_RLAST;
  wire gp0_smc_M29_AXI_RREADY;
  wire [1:0]gp0_smc_M29_AXI_RRESP;
  wire [13:0]gp0_smc_M29_AXI_RUSER;
  wire gp0_smc_M29_AXI_RVALID;
  wire [31:0]gp0_smc_M29_AXI_WDATA;
  wire gp0_smc_M29_AXI_WLAST;
  wire gp0_smc_M29_AXI_WREADY;
  wire [3:0]gp0_smc_M29_AXI_WSTRB;
  wire [13:0]gp0_smc_M29_AXI_WUSER;
  wire gp0_smc_M29_AXI_WVALID;
  wire [11:0]gp0_smc_M30_AXI_ARADDR;
  wire [2:0]gp0_smc_M30_AXI_ARPROT;
  wire gp0_smc_M30_AXI_ARREADY;
  wire gp0_smc_M30_AXI_ARVALID;
  wire [11:0]gp0_smc_M30_AXI_AWADDR;
  wire [2:0]gp0_smc_M30_AXI_AWPROT;
  wire gp0_smc_M30_AXI_AWREADY;
  wire gp0_smc_M30_AXI_AWVALID;
  wire gp0_smc_M30_AXI_BREADY;
  wire [1:0]gp0_smc_M30_AXI_BRESP;
  wire gp0_smc_M30_AXI_BVALID;
  wire [31:0]gp0_smc_M30_AXI_RDATA;
  wire gp0_smc_M30_AXI_RREADY;
  wire [1:0]gp0_smc_M30_AXI_RRESP;
  wire gp0_smc_M30_AXI_RVALID;
  wire [31:0]gp0_smc_M30_AXI_WDATA;
  wire gp0_smc_M30_AXI_WREADY;
  wire [3:0]gp0_smc_M30_AXI_WSTRB;
  wire gp0_smc_M30_AXI_WVALID;
  wire hdmi_out_clk_n;
  wire hdmi_out_clk_p;
  wire [2:0]hdmi_out_data_n;
  wire [2:0]hdmi_out_data_p;
  wire [31:0]hp0_smc_M00_AXI_ARADDR;
  wire [1:0]hp0_smc_M00_AXI_ARBURST;
  wire [3:0]hp0_smc_M00_AXI_ARCACHE;
  wire [3:0]hp0_smc_M00_AXI_ARLEN;
  wire [1:0]hp0_smc_M00_AXI_ARLOCK;
  wire [2:0]hp0_smc_M00_AXI_ARPROT;
  wire [3:0]hp0_smc_M00_AXI_ARQOS;
  wire hp0_smc_M00_AXI_ARREADY;
  wire [2:0]hp0_smc_M00_AXI_ARSIZE;
  wire hp0_smc_M00_AXI_ARVALID;
  wire [63:0]hp0_smc_M00_AXI_RDATA;
  wire hp0_smc_M00_AXI_RLAST;
  wire hp0_smc_M00_AXI_RREADY;
  wire [1:0]hp0_smc_M00_AXI_RRESP;
  wire hp0_smc_M00_AXI_RVALID;
  wire [31:0]hp2_smc_M00_AXI_AWADDR;
  wire [1:0]hp2_smc_M00_AXI_AWBURST;
  wire [3:0]hp2_smc_M00_AXI_AWCACHE;
  wire [3:0]hp2_smc_M00_AXI_AWLEN;
  wire [1:0]hp2_smc_M00_AXI_AWLOCK;
  wire [2:0]hp2_smc_M00_AXI_AWPROT;
  wire [3:0]hp2_smc_M00_AXI_AWQOS;
  wire hp2_smc_M00_AXI_AWREADY;
  wire [2:0]hp2_smc_M00_AXI_AWSIZE;
  wire hp2_smc_M00_AXI_AWVALID;
  wire hp2_smc_M00_AXI_BREADY;
  wire [1:0]hp2_smc_M00_AXI_BRESP;
  wire hp2_smc_M00_AXI_BVALID;
  wire [63:0]hp2_smc_M00_AXI_WDATA;
  wire hp2_smc_M00_AXI_WLAST;
  wire hp2_smc_M00_AXI_WREADY;
  wire [7:0]hp2_smc_M00_AXI_WSTRB;
  wire hp2_smc_M00_AXI_WVALID;
  wire input_osd_0_out_de;
  wire input_osd_0_out_hs;
  wire [23:0]input_osd_0_out_rgb;
  wire input_osd_0_out_vs;
  wire [4:0]irq_concat_dout;
  wire lrclk;
  wire [31:0]moments_dma_M_AXI_S2MM_AWADDR;
  wire [1:0]moments_dma_M_AXI_S2MM_AWBURST;
  wire [3:0]moments_dma_M_AXI_S2MM_AWCACHE;
  wire [7:0]moments_dma_M_AXI_S2MM_AWLEN;
  wire [2:0]moments_dma_M_AXI_S2MM_AWPROT;
  wire moments_dma_M_AXI_S2MM_AWREADY;
  wire [2:0]moments_dma_M_AXI_S2MM_AWSIZE;
  wire moments_dma_M_AXI_S2MM_AWVALID;
  wire moments_dma_M_AXI_S2MM_BREADY;
  wire [1:0]moments_dma_M_AXI_S2MM_BRESP;
  wire moments_dma_M_AXI_S2MM_BVALID;
  wire [63:0]moments_dma_M_AXI_S2MM_WDATA;
  wire moments_dma_M_AXI_S2MM_WLAST;
  wire moments_dma_M_AXI_S2MM_WREADY;
  wire [7:0]moments_dma_M_AXI_S2MM_WSTRB;
  wire moments_dma_M_AXI_S2MM_WVALID;
  wire [31:0]moments_dma_M_AXI_SG_ARADDR;
  wire [1:0]moments_dma_M_AXI_SG_ARBURST;
  wire [3:0]moments_dma_M_AXI_SG_ARCACHE;
  wire [7:0]moments_dma_M_AXI_SG_ARLEN;
  wire [2:0]moments_dma_M_AXI_SG_ARPROT;
  wire moments_dma_M_AXI_SG_ARREADY;
  wire [2:0]moments_dma_M_AXI_SG_ARSIZE;
  wire moments_dma_M_AXI_SG_ARVALID;
  wire [31:0]moments_dma_M_AXI_SG_AWADDR;
  wire [1:0]moments_dma_M_AXI_SG_AWBURST;
  wire [3:0]moments_dma_M_AXI_SG_AWCACHE;
  wire [7:0]moments_dma_M_AXI_SG_AWLEN;
  wire [2:0]moments_dma_M_AXI_SG_AWPROT;
  wire moments_dma_M_AXI_SG_AWREADY;
  wire [2:0]moments_dma_M_AXI_SG_AWSIZE;
  wire moments_dma_M_AXI_SG_AWVALID;
  wire moments_dma_M_AXI_SG_BREADY;
  wire [1:0]moments_dma_M_AXI_SG_BRESP;
  wire moments_dma_M_AXI_SG_BVALID;
  wire [31:0]moments_dma_M_AXI_SG_RDATA;
  wire moments_dma_M_AXI_SG_RLAST;
  wire moments_dma_M_AXI_SG_RREADY;
  wire [1:0]moments_dma_M_AXI_SG_RRESP;
  wire moments_dma_M_AXI_SG_RVALID;
  wire [31:0]moments_dma_M_AXI_SG_WDATA;
  wire moments_dma_M_AXI_SG_WLAST;
  wire moments_dma_M_AXI_SG_WREADY;
  wire [3:0]moments_dma_M_AXI_SG_WSTRB;
  wire moments_dma_M_AXI_SG_WVALID;
  wire moments_dma_s2mm_introut;
  wire [0:0]moments_reset_gpio_io_o;
  wire [0:0]overlap_release_constant_dout;
  wire [63:0]packet_stream_width_M_AXIS_TDATA;
  wire [7:0]packet_stream_width_M_AXIS_TKEEP;
  wire packet_stream_width_M_AXIS_TLAST;
  wire packet_stream_width_M_AXIS_TREADY;
  wire packet_stream_width_M_AXIS_TVALID;
  wire pixel_clock_clk_out1;
  wire pixel_clock_locked;
  wire ps7_0_FCLK_CLK0;
  wire ps7_0_FCLK_RESET0_N;
  wire [31:0]ps7_0_M_AXI_GP0_ARADDR;
  wire [1:0]ps7_0_M_AXI_GP0_ARBURST;
  wire [3:0]ps7_0_M_AXI_GP0_ARCACHE;
  wire [11:0]ps7_0_M_AXI_GP0_ARID;
  wire [3:0]ps7_0_M_AXI_GP0_ARLEN;
  wire [1:0]ps7_0_M_AXI_GP0_ARLOCK;
  wire [2:0]ps7_0_M_AXI_GP0_ARPROT;
  wire [3:0]ps7_0_M_AXI_GP0_ARQOS;
  wire ps7_0_M_AXI_GP0_ARREADY;
  wire [2:0]ps7_0_M_AXI_GP0_ARSIZE;
  wire ps7_0_M_AXI_GP0_ARVALID;
  wire [31:0]ps7_0_M_AXI_GP0_AWADDR;
  wire [1:0]ps7_0_M_AXI_GP0_AWBURST;
  wire [3:0]ps7_0_M_AXI_GP0_AWCACHE;
  wire [11:0]ps7_0_M_AXI_GP0_AWID;
  wire [3:0]ps7_0_M_AXI_GP0_AWLEN;
  wire [1:0]ps7_0_M_AXI_GP0_AWLOCK;
  wire [2:0]ps7_0_M_AXI_GP0_AWPROT;
  wire [3:0]ps7_0_M_AXI_GP0_AWQOS;
  wire ps7_0_M_AXI_GP0_AWREADY;
  wire [2:0]ps7_0_M_AXI_GP0_AWSIZE;
  wire ps7_0_M_AXI_GP0_AWVALID;
  wire [11:0]ps7_0_M_AXI_GP0_BID;
  wire ps7_0_M_AXI_GP0_BREADY;
  wire [1:0]ps7_0_M_AXI_GP0_BRESP;
  wire ps7_0_M_AXI_GP0_BVALID;
  wire [31:0]ps7_0_M_AXI_GP0_RDATA;
  wire [11:0]ps7_0_M_AXI_GP0_RID;
  wire ps7_0_M_AXI_GP0_RLAST;
  wire ps7_0_M_AXI_GP0_RREADY;
  wire [1:0]ps7_0_M_AXI_GP0_RRESP;
  wire ps7_0_M_AXI_GP0_RVALID;
  wire [31:0]ps7_0_M_AXI_GP0_WDATA;
  wire [11:0]ps7_0_M_AXI_GP0_WID;
  wire ps7_0_M_AXI_GP0_WLAST;
  wire ps7_0_M_AXI_GP0_WREADY;
  wire [3:0]ps7_0_M_AXI_GP0_WSTRB;
  wire ps7_0_M_AXI_GP0_WVALID;
  wire [31:0]return_control_gpio_gpio2_io_o;
  wire [31:0]return_control_gpio_gpio_io_o;
  wire [31:0]return_dma_M_AXI_S2MM_AWADDR;
  wire [1:0]return_dma_M_AXI_S2MM_AWBURST;
  wire [3:0]return_dma_M_AXI_S2MM_AWCACHE;
  wire [7:0]return_dma_M_AXI_S2MM_AWLEN;
  wire [2:0]return_dma_M_AXI_S2MM_AWPROT;
  wire return_dma_M_AXI_S2MM_AWREADY;
  wire [2:0]return_dma_M_AXI_S2MM_AWSIZE;
  wire return_dma_M_AXI_S2MM_AWVALID;
  wire return_dma_M_AXI_S2MM_BREADY;
  wire [1:0]return_dma_M_AXI_S2MM_BRESP;
  wire return_dma_M_AXI_S2MM_BVALID;
  wire [63:0]return_dma_M_AXI_S2MM_WDATA;
  wire return_dma_M_AXI_S2MM_WLAST;
  wire return_dma_M_AXI_S2MM_WREADY;
  wire [7:0]return_dma_M_AXI_S2MM_WSTRB;
  wire return_dma_M_AXI_S2MM_WVALID;
  wire return_dma_s2mm_introut;
  wire [63:0]return_source_M_AXIS_TDATA;
  wire [7:0]return_source_M_AXIS_TKEEP;
  wire return_source_M_AXIS_TLAST;
  wire return_source_M_AXIS_TREADY;
  wire return_source_M_AXIS_TVALID;
  wire return_source_busy;
  wire [31:0]return_source_completed_byte_count;
  wire [31:0]return_source_completed_packet_count;
  wire [31:0]return_source_rejected_start_count;
  wire [0:0]return_start_gpio_gpio_io_o;
  wire [0:0]rst_fclk0_interconnect_aresetn;
  wire [0:0]rst_fclk0_peripheral_aresetn;
  wire [0:0]rst_fclk0_peripheral_reset;
  wire [0:0]rst_pixel_peripheral_aresetn;
  wire [0:0]rst_pixel_peripheral_reset;
  wire sdata_i;
  wire [0:0]sdata_o;
  wire [31:0]skin_hp3_smc_M00_AXI_ARADDR;
  wire [1:0]skin_hp3_smc_M00_AXI_ARBURST;
  wire [3:0]skin_hp3_smc_M00_AXI_ARCACHE;
  wire [3:0]skin_hp3_smc_M00_AXI_ARLEN;
  wire [1:0]skin_hp3_smc_M00_AXI_ARLOCK;
  wire [2:0]skin_hp3_smc_M00_AXI_ARPROT;
  wire [3:0]skin_hp3_smc_M00_AXI_ARQOS;
  wire skin_hp3_smc_M00_AXI_ARREADY;
  wire [2:0]skin_hp3_smc_M00_AXI_ARSIZE;
  wire skin_hp3_smc_M00_AXI_ARVALID;
  wire [31:0]skin_hp3_smc_M00_AXI_AWADDR;
  wire [1:0]skin_hp3_smc_M00_AXI_AWBURST;
  wire [3:0]skin_hp3_smc_M00_AXI_AWCACHE;
  wire [3:0]skin_hp3_smc_M00_AXI_AWLEN;
  wire [1:0]skin_hp3_smc_M00_AXI_AWLOCK;
  wire [2:0]skin_hp3_smc_M00_AXI_AWPROT;
  wire [3:0]skin_hp3_smc_M00_AXI_AWQOS;
  wire skin_hp3_smc_M00_AXI_AWREADY;
  wire [2:0]skin_hp3_smc_M00_AXI_AWSIZE;
  wire skin_hp3_smc_M00_AXI_AWVALID;
  wire skin_hp3_smc_M00_AXI_BREADY;
  wire [1:0]skin_hp3_smc_M00_AXI_BRESP;
  wire skin_hp3_smc_M00_AXI_BVALID;
  wire [63:0]skin_hp3_smc_M00_AXI_RDATA;
  wire skin_hp3_smc_M00_AXI_RLAST;
  wire skin_hp3_smc_M00_AXI_RREADY;
  wire [1:0]skin_hp3_smc_M00_AXI_RRESP;
  wire skin_hp3_smc_M00_AXI_RVALID;
  wire [63:0]skin_hp3_smc_M00_AXI_WDATA;
  wire skin_hp3_smc_M00_AXI_WLAST;
  wire skin_hp3_smc_M00_AXI_WREADY;
  wire [7:0]skin_hp3_smc_M00_AXI_WSTRB;
  wire skin_hp3_smc_M00_AXI_WVALID;
  wire [0:0]skin_reset_and_Res;
  wire [7:0]vid_data;
  wire vid_hsync;
  wire vid_iic_scl_i;
  wire vid_iic_scl_o;
  wire vid_iic_scl_t;
  wire vid_iic_sda_i;
  wire vid_iic_sda_o;
  wire vid_iic_sda_t;
  wire vid_pclk;
  wire vid_vsync;
  wire vid_xclk;
  wire video_in_overflow;
  wire video_in_underflow;
  wire [7:0]video_in_video_out_TDATA;
  wire video_in_video_out_TLAST;
  wire video_in_video_out_TREADY;
  wire video_in_video_out_TUSER;
  wire video_in_video_out_TVALID;
  wire [8:0]vision_control_smc_M00_AXI_ARADDR;
  wire vision_control_smc_M00_AXI_ARREADY;
  wire vision_control_smc_M00_AXI_ARVALID;
  wire [8:0]vision_control_smc_M00_AXI_AWADDR;
  wire vision_control_smc_M00_AXI_AWREADY;
  wire vision_control_smc_M00_AXI_AWVALID;
  wire vision_control_smc_M00_AXI_BREADY;
  wire [1:0]vision_control_smc_M00_AXI_BRESP;
  wire vision_control_smc_M00_AXI_BVALID;
  wire [31:0]vision_control_smc_M00_AXI_RDATA;
  wire vision_control_smc_M00_AXI_RREADY;
  wire [1:0]vision_control_smc_M00_AXI_RRESP;
  wire vision_control_smc_M00_AXI_RVALID;
  wire [31:0]vision_control_smc_M00_AXI_WDATA;
  wire vision_control_smc_M00_AXI_WREADY;
  wire [3:0]vision_control_smc_M00_AXI_WSTRB;
  wire vision_control_smc_M00_AXI_WVALID;
  wire [5:0]vision_control_smc_M01_AXI_ARADDR;
  wire vision_control_smc_M01_AXI_ARREADY;
  wire vision_control_smc_M01_AXI_ARVALID;
  wire [5:0]vision_control_smc_M01_AXI_AWADDR;
  wire vision_control_smc_M01_AXI_AWREADY;
  wire vision_control_smc_M01_AXI_AWVALID;
  wire vision_control_smc_M01_AXI_BREADY;
  wire [1:0]vision_control_smc_M01_AXI_BRESP;
  wire vision_control_smc_M01_AXI_BVALID;
  wire [31:0]vision_control_smc_M01_AXI_RDATA;
  wire vision_control_smc_M01_AXI_RREADY;
  wire [1:0]vision_control_smc_M01_AXI_RRESP;
  wire vision_control_smc_M01_AXI_RVALID;
  wire [31:0]vision_control_smc_M01_AXI_WDATA;
  wire vision_control_smc_M01_AXI_WREADY;
  wire [3:0]vision_control_smc_M01_AXI_WSTRB;
  wire vision_control_smc_M01_AXI_WVALID;
  wire [8:0]vision_control_smc_M02_AXI_ARADDR;
  wire vision_control_smc_M02_AXI_ARREADY;
  wire vision_control_smc_M02_AXI_ARVALID;
  wire [8:0]vision_control_smc_M02_AXI_AWADDR;
  wire vision_control_smc_M02_AXI_AWREADY;
  wire vision_control_smc_M02_AXI_AWVALID;
  wire vision_control_smc_M02_AXI_BREADY;
  wire [1:0]vision_control_smc_M02_AXI_BRESP;
  wire vision_control_smc_M02_AXI_BVALID;
  wire [31:0]vision_control_smc_M02_AXI_RDATA;
  wire vision_control_smc_M02_AXI_RREADY;
  wire [1:0]vision_control_smc_M02_AXI_RRESP;
  wire vision_control_smc_M02_AXI_RVALID;
  wire [31:0]vision_control_smc_M02_AXI_WDATA;
  wire vision_control_smc_M02_AXI_WREADY;
  wire vision_control_smc_M02_AXI_WVALID;
  wire [9:0]vision_control_smc_M03_AXI_ARADDR;
  wire vision_control_smc_M03_AXI_ARREADY;
  wire vision_control_smc_M03_AXI_ARVALID;
  wire [9:0]vision_control_smc_M03_AXI_AWADDR;
  wire vision_control_smc_M03_AXI_AWREADY;
  wire vision_control_smc_M03_AXI_AWVALID;
  wire vision_control_smc_M03_AXI_BREADY;
  wire [1:0]vision_control_smc_M03_AXI_BRESP;
  wire vision_control_smc_M03_AXI_BVALID;
  wire [31:0]vision_control_smc_M03_AXI_RDATA;
  wire vision_control_smc_M03_AXI_RREADY;
  wire [1:0]vision_control_smc_M03_AXI_RRESP;
  wire vision_control_smc_M03_AXI_RVALID;
  wire [31:0]vision_control_smc_M03_AXI_WDATA;
  wire vision_control_smc_M03_AXI_WREADY;
  wire vision_control_smc_M03_AXI_WVALID;
  wire [8:0]vision_control_smc_M04_AXI_ARADDR;
  wire vision_control_smc_M04_AXI_ARREADY;
  wire vision_control_smc_M04_AXI_ARVALID;
  wire [8:0]vision_control_smc_M04_AXI_AWADDR;
  wire vision_control_smc_M04_AXI_AWREADY;
  wire vision_control_smc_M04_AXI_AWVALID;
  wire vision_control_smc_M04_AXI_BREADY;
  wire [1:0]vision_control_smc_M04_AXI_BRESP;
  wire vision_control_smc_M04_AXI_BVALID;
  wire [31:0]vision_control_smc_M04_AXI_RDATA;
  wire vision_control_smc_M04_AXI_RREADY;
  wire [1:0]vision_control_smc_M04_AXI_RRESP;
  wire vision_control_smc_M04_AXI_RVALID;
  wire [31:0]vision_control_smc_M04_AXI_WDATA;
  wire vision_control_smc_M04_AXI_WREADY;
  wire [3:0]vision_control_smc_M04_AXI_WSTRB;
  wire vision_control_smc_M04_AXI_WVALID;
  wire [6:0]vision_control_smc_M05_AXI_ARADDR;
  wire [2:0]vision_control_smc_M05_AXI_ARPROT;
  wire vision_control_smc_M05_AXI_ARREADY;
  wire vision_control_smc_M05_AXI_ARVALID;
  wire [6:0]vision_control_smc_M05_AXI_AWADDR;
  wire [2:0]vision_control_smc_M05_AXI_AWPROT;
  wire vision_control_smc_M05_AXI_AWREADY;
  wire vision_control_smc_M05_AXI_AWVALID;
  wire vision_control_smc_M05_AXI_BREADY;
  wire [1:0]vision_control_smc_M05_AXI_BRESP;
  wire vision_control_smc_M05_AXI_BVALID;
  wire [31:0]vision_control_smc_M05_AXI_RDATA;
  wire vision_control_smc_M05_AXI_RREADY;
  wire [1:0]vision_control_smc_M05_AXI_RRESP;
  wire vision_control_smc_M05_AXI_RVALID;
  wire [31:0]vision_control_smc_M05_AXI_WDATA;
  wire vision_control_smc_M05_AXI_WREADY;
  wire [3:0]vision_control_smc_M05_AXI_WSTRB;
  wire vision_control_smc_M05_AXI_WVALID;
  wire [11:0]vision_control_smc_M06_AXI_ARADDR;
  wire vision_control_smc_M06_AXI_ARREADY;
  wire vision_control_smc_M06_AXI_ARVALID;
  wire [11:0]vision_control_smc_M06_AXI_AWADDR;
  wire vision_control_smc_M06_AXI_AWREADY;
  wire vision_control_smc_M06_AXI_AWVALID;
  wire vision_control_smc_M06_AXI_BREADY;
  wire [1:0]vision_control_smc_M06_AXI_BRESP;
  wire vision_control_smc_M06_AXI_BVALID;
  wire [31:0]vision_control_smc_M06_AXI_RDATA;
  wire vision_control_smc_M06_AXI_RREADY;
  wire [1:0]vision_control_smc_M06_AXI_RRESP;
  wire vision_control_smc_M06_AXI_RVALID;
  wire [31:0]vision_control_smc_M06_AXI_WDATA;
  wire vision_control_smc_M06_AXI_WREADY;
  wire [3:0]vision_control_smc_M06_AXI_WSTRB;
  wire vision_control_smc_M06_AXI_WVALID;
  wire [11:0]vision_control_smc_M07_AXI_ARADDR;
  wire vision_control_smc_M07_AXI_ARREADY;
  wire vision_control_smc_M07_AXI_ARVALID;
  wire [11:0]vision_control_smc_M07_AXI_AWADDR;
  wire vision_control_smc_M07_AXI_AWREADY;
  wire vision_control_smc_M07_AXI_AWVALID;
  wire vision_control_smc_M07_AXI_BREADY;
  wire [1:0]vision_control_smc_M07_AXI_BRESP;
  wire vision_control_smc_M07_AXI_BVALID;
  wire [31:0]vision_control_smc_M07_AXI_RDATA;
  wire vision_control_smc_M07_AXI_RREADY;
  wire [1:0]vision_control_smc_M07_AXI_RRESP;
  wire vision_control_smc_M07_AXI_RVALID;
  wire [31:0]vision_control_smc_M07_AXI_WDATA;
  wire vision_control_smc_M07_AXI_WREADY;
  wire [3:0]vision_control_smc_M07_AXI_WSTRB;
  wire vision_control_smc_M07_AXI_WVALID;
  wire [31:0]vision_gp0_slice_M_AXI_ARADDR;
  wire [1:0]vision_gp0_slice_M_AXI_ARBURST;
  wire [3:0]vision_gp0_slice_M_AXI_ARCACHE;
  wire [11:0]vision_gp0_slice_M_AXI_ARID;
  wire [3:0]vision_gp0_slice_M_AXI_ARLEN;
  wire [1:0]vision_gp0_slice_M_AXI_ARLOCK;
  wire [2:0]vision_gp0_slice_M_AXI_ARPROT;
  wire [3:0]vision_gp0_slice_M_AXI_ARQOS;
  wire vision_gp0_slice_M_AXI_ARREADY;
  wire [2:0]vision_gp0_slice_M_AXI_ARSIZE;
  wire vision_gp0_slice_M_AXI_ARVALID;
  wire [31:0]vision_gp0_slice_M_AXI_AWADDR;
  wire [1:0]vision_gp0_slice_M_AXI_AWBURST;
  wire [3:0]vision_gp0_slice_M_AXI_AWCACHE;
  wire [11:0]vision_gp0_slice_M_AXI_AWID;
  wire [3:0]vision_gp0_slice_M_AXI_AWLEN;
  wire [1:0]vision_gp0_slice_M_AXI_AWLOCK;
  wire [2:0]vision_gp0_slice_M_AXI_AWPROT;
  wire [3:0]vision_gp0_slice_M_AXI_AWQOS;
  wire vision_gp0_slice_M_AXI_AWREADY;
  wire [2:0]vision_gp0_slice_M_AXI_AWSIZE;
  wire vision_gp0_slice_M_AXI_AWVALID;
  wire [11:0]vision_gp0_slice_M_AXI_BID;
  wire vision_gp0_slice_M_AXI_BREADY;
  wire [1:0]vision_gp0_slice_M_AXI_BRESP;
  wire vision_gp0_slice_M_AXI_BVALID;
  wire [31:0]vision_gp0_slice_M_AXI_RDATA;
  wire [11:0]vision_gp0_slice_M_AXI_RID;
  wire vision_gp0_slice_M_AXI_RLAST;
  wire vision_gp0_slice_M_AXI_RREADY;
  wire [1:0]vision_gp0_slice_M_AXI_RRESP;
  wire vision_gp0_slice_M_AXI_RVALID;
  wire [31:0]vision_gp0_slice_M_AXI_WDATA;
  wire [11:0]vision_gp0_slice_M_AXI_WID;
  wire vision_gp0_slice_M_AXI_WLAST;
  wire vision_gp0_slice_M_AXI_WREADY;
  wire [3:0]vision_gp0_slice_M_AXI_WSTRB;
  wire vision_gp0_slice_M_AXI_WVALID;

  c6v_asset_generation_status_gpio_0 asset_generation_status_gpio
       (.gpio2_io_i(core_asset_error_flags),
        .gpio_io_i(core_asset_generation),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M19_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M19_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M19_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M19_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M19_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M19_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M19_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M19_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M19_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M19_AXI_RDATA),
        .s_axi_rready(gp0_smc_M19_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M19_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M19_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M19_AXI_WDATA),
        .s_axi_wready(gp0_smc_M19_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M19_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M19_AXI_WVALID));
  c6v_asset_packet_status_gpio_0 asset_packet_status_gpio
       (.gpio2_io_i(core_asset_rejected_packet_count),
        .gpio_io_i(core_asset_accepted_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M18_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M18_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M18_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M18_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M18_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M18_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M18_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M18_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M18_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M18_AXI_RDATA),
        .s_axi_rready(gp0_smc_M18_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M18_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M18_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M18_AXI_WDATA),
        .s_axi_wready(gp0_smc_M18_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M18_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M18_AXI_WVALID));
  c6v_asset_state_status_gpio_0 asset_state_status_gpio
       (.gpio_io_i(core_asset_status),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M20_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M20_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M20_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M20_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M20_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M20_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M20_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M20_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M20_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M20_AXI_RDATA),
        .s_axi_rready(gp0_smc_M20_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M20_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M20_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M20_AXI_WDATA),
        .s_axi_wready(gp0_smc_M20_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M20_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M20_AXI_WVALID));
  c6v_audio_mclk_0 audio_mclk
       (.clk_in1(ps7_0_FCLK_CLK0),
        .clk_out1(audio_clk_10MHz),
        .locked(audio_mclk_locked));
  c6v_axi_dma_0 axi_dma
       (.axi_resetn(rst_fclk0_peripheral_aresetn),
        .m_axi_mm2s_aclk(ps7_0_FCLK_CLK0),
        .m_axi_mm2s_araddr(axi_dma_M_AXI_MM2S_ARADDR),
        .m_axi_mm2s_arburst(axi_dma_M_AXI_MM2S_ARBURST),
        .m_axi_mm2s_arcache(axi_dma_M_AXI_MM2S_ARCACHE),
        .m_axi_mm2s_arlen(axi_dma_M_AXI_MM2S_ARLEN),
        .m_axi_mm2s_arprot(axi_dma_M_AXI_MM2S_ARPROT),
        .m_axi_mm2s_arready(axi_dma_M_AXI_MM2S_ARREADY),
        .m_axi_mm2s_arsize(axi_dma_M_AXI_MM2S_ARSIZE),
        .m_axi_mm2s_arvalid(axi_dma_M_AXI_MM2S_ARVALID),
        .m_axi_mm2s_rdata(axi_dma_M_AXI_MM2S_RDATA),
        .m_axi_mm2s_rlast(axi_dma_M_AXI_MM2S_RLAST),
        .m_axi_mm2s_rready(axi_dma_M_AXI_MM2S_RREADY),
        .m_axi_mm2s_rresp(axi_dma_M_AXI_MM2S_RRESP),
        .m_axi_mm2s_rvalid(axi_dma_M_AXI_MM2S_RVALID),
        .m_axis_mm2s_tdata(axi_dma_m_axis_mm2s_tdata),
        .m_axis_mm2s_tkeep(axi_dma_m_axis_mm2s_tkeep),
        .m_axis_mm2s_tlast(axi_dma_m_axis_mm2s_tlast),
        .m_axis_mm2s_tready(core_s_axis_tready),
        .m_axis_mm2s_tvalid(axi_dma_m_axis_mm2s_tvalid),
        .mm2s_introut(axi_dma_mm2s_introut),
        .s_axi_lite_aclk(ps7_0_FCLK_CLK0),
        .s_axi_lite_araddr(gp0_smc_M00_AXI_ARADDR),
        .s_axi_lite_arready(gp0_smc_M00_AXI_ARREADY),
        .s_axi_lite_arvalid(gp0_smc_M00_AXI_ARVALID),
        .s_axi_lite_awaddr(gp0_smc_M00_AXI_AWADDR),
        .s_axi_lite_awready(gp0_smc_M00_AXI_AWREADY),
        .s_axi_lite_awvalid(gp0_smc_M00_AXI_AWVALID),
        .s_axi_lite_bready(gp0_smc_M00_AXI_BREADY),
        .s_axi_lite_bresp(gp0_smc_M00_AXI_BRESP),
        .s_axi_lite_bvalid(gp0_smc_M00_AXI_BVALID),
        .s_axi_lite_rdata(gp0_smc_M00_AXI_RDATA),
        .s_axi_lite_rready(gp0_smc_M00_AXI_RREADY),
        .s_axi_lite_rresp(gp0_smc_M00_AXI_RRESP),
        .s_axi_lite_rvalid(gp0_smc_M00_AXI_RVALID),
        .s_axi_lite_wdata(gp0_smc_M00_AXI_WDATA),
        .s_axi_lite_wready(gp0_smc_M00_AXI_WREADY),
        .s_axi_lite_wvalid(gp0_smc_M00_AXI_WVALID));
  c6v_build_id_constant_0 build_id_constant
       (.dout(build_id_constant_dout));
  c6v_build_id_gpio_0 build_id_gpio
       (.gpio_io_i(build_id_constant_dout),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M01_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M01_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M01_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M01_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M01_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M01_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M01_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M01_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M01_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M01_AXI_RDATA),
        .s_axi_rready(gp0_smc_M01_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M01_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M01_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M01_AXI_WDATA),
        .s_axi_wready(gp0_smc_M01_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M01_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M01_AXI_WVALID));
  c6v_camera_hp1_smc_0 camera_hp1_smc
       (.M00_AXI_awaddr(camera_hp1_smc_M00_AXI_AWADDR),
        .M00_AXI_awburst(camera_hp1_smc_M00_AXI_AWBURST),
        .M00_AXI_awcache(camera_hp1_smc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(camera_hp1_smc_M00_AXI_AWLEN),
        .M00_AXI_awlock(camera_hp1_smc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(camera_hp1_smc_M00_AXI_AWPROT),
        .M00_AXI_awqos(camera_hp1_smc_M00_AXI_AWQOS),
        .M00_AXI_awready(camera_hp1_smc_M00_AXI_AWREADY),
        .M00_AXI_awsize(camera_hp1_smc_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(camera_hp1_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(camera_hp1_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(camera_hp1_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(camera_hp1_smc_M00_AXI_BVALID),
        .M00_AXI_wdata(camera_hp1_smc_M00_AXI_WDATA),
        .M00_AXI_wlast(camera_hp1_smc_M00_AXI_WLAST),
        .M00_AXI_wready(camera_hp1_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(camera_hp1_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(camera_hp1_smc_M00_AXI_WVALID),
        .S00_AXI_awaddr(frame_dma_M_AXI_S2MM_AWADDR),
        .S00_AXI_awburst(frame_dma_M_AXI_S2MM_AWBURST),
        .S00_AXI_awcache(frame_dma_M_AXI_S2MM_AWCACHE),
        .S00_AXI_awlen(frame_dma_M_AXI_S2MM_AWLEN),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot(frame_dma_M_AXI_S2MM_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(frame_dma_M_AXI_S2MM_AWREADY),
        .S00_AXI_awsize(frame_dma_M_AXI_S2MM_AWSIZE),
        .S00_AXI_awvalid(frame_dma_M_AXI_S2MM_AWVALID),
        .S00_AXI_bready(frame_dma_M_AXI_S2MM_BREADY),
        .S00_AXI_bresp(frame_dma_M_AXI_S2MM_BRESP),
        .S00_AXI_bvalid(frame_dma_M_AXI_S2MM_BVALID),
        .S00_AXI_wdata(frame_dma_M_AXI_S2MM_WDATA),
        .S00_AXI_wlast(frame_dma_M_AXI_S2MM_WLAST),
        .S00_AXI_wready(frame_dma_M_AXI_S2MM_WREADY),
        .S00_AXI_wstrb(frame_dma_M_AXI_S2MM_WSTRB),
        .S00_AXI_wvalid(frame_dma_M_AXI_S2MM_WVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_camera_iic_0 camera_iic
       (.s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(vision_control_smc_M00_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(vision_control_smc_M00_AXI_ARREADY),
        .s_axi_arvalid(vision_control_smc_M00_AXI_ARVALID),
        .s_axi_awaddr(vision_control_smc_M00_AXI_AWADDR),
        .s_axi_awready(vision_control_smc_M00_AXI_AWREADY),
        .s_axi_awvalid(vision_control_smc_M00_AXI_AWVALID),
        .s_axi_bready(vision_control_smc_M00_AXI_BREADY),
        .s_axi_bresp(vision_control_smc_M00_AXI_BRESP),
        .s_axi_bvalid(vision_control_smc_M00_AXI_BVALID),
        .s_axi_rdata(vision_control_smc_M00_AXI_RDATA),
        .s_axi_rready(vision_control_smc_M00_AXI_RREADY),
        .s_axi_rresp(vision_control_smc_M00_AXI_RRESP),
        .s_axi_rvalid(vision_control_smc_M00_AXI_RVALID),
        .s_axi_wdata(vision_control_smc_M00_AXI_WDATA),
        .s_axi_wready(vision_control_smc_M00_AXI_WREADY),
        .s_axi_wstrb(vision_control_smc_M00_AXI_WSTRB),
        .s_axi_wvalid(vision_control_smc_M00_AXI_WVALID),
        .scl_i(vid_iic_scl_i),
        .scl_o(vid_iic_scl_o),
        .scl_t(vid_iic_scl_t),
        .sda_i(vid_iic_sda_i),
        .sda_o(vid_iic_sda_o),
        .sda_t(vid_iic_sda_t));
  c6v_capture_control_0 capture_control
       (.abort_requested(capture_control_abort_requested),
        .armed(capture_control_armed),
        .barrier_request(capture_control_barrier_request),
        .capture_aresetn(capture_control_capture_aresetn),
        .cfg_frame_context(capture_control_cfg_frame_context),
        .common_aresetn(rst_fclk0_peripheral_aresetn),
        .owner_available(capture_lifecycle_cpu_available),
        .owner_claim_accepted(capture_lifecycle_claim_accepted),
        .owner_command_fault(capture_control_owner_command_fault),
        .owner_cpu_claim(capture_control_owner_cpu_claim),
        .owner_cpu_epoch(capture_control_owner_cpu_epoch),
        .owner_cpu_frame_id(capture_control_owner_cpu_frame_id),
        .owner_cpu_held(capture_lifecycle_cpu_held),
        .owner_cpu_release(capture_control_owner_cpu_release),
        .owner_drained(capture_lifecycle_owner_drained),
        .owner_epoch(capture_lifecycle_available_epoch),
        .owner_fault(capture_lifecycle_owner_fault),
        .owner_fault_causes(capture_lifecycle_owner_fault_causes),
        .owner_frame_id(capture_lifecycle_available_frame_id),
        .owner_granted_frames(capture_lifecycle_granted_frames),
        .owner_release_accepted(capture_lifecycle_release_accepted),
        .owner_released_frames(capture_lifecycle_released_frames),
        .owner_slot(capture_lifecycle_available_slot),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(vision_control_smc_M06_AXI_ARADDR),
        .s_axi_aresetn(skin_reset_and_Res),
        .s_axi_arready(vision_control_smc_M06_AXI_ARREADY),
        .s_axi_arvalid(vision_control_smc_M06_AXI_ARVALID),
        .s_axi_awaddr(vision_control_smc_M06_AXI_AWADDR),
        .s_axi_awready(vision_control_smc_M06_AXI_AWREADY),
        .s_axi_awvalid(vision_control_smc_M06_AXI_AWVALID),
        .s_axi_bready(vision_control_smc_M06_AXI_BREADY),
        .s_axi_bresp(vision_control_smc_M06_AXI_BRESP),
        .s_axi_bvalid(vision_control_smc_M06_AXI_BVALID),
        .s_axi_rdata(vision_control_smc_M06_AXI_RDATA),
        .s_axi_rready(vision_control_smc_M06_AXI_RREADY),
        .s_axi_rresp(vision_control_smc_M06_AXI_RRESP),
        .s_axi_rvalid(vision_control_smc_M06_AXI_RVALID),
        .s_axi_wdata(vision_control_smc_M06_AXI_WDATA),
        .s_axi_wready(vision_control_smc_M06_AXI_WREADY),
        .s_axi_wstrb(vision_control_smc_M06_AXI_WSTRB),
        .s_axi_wvalid(vision_control_smc_M06_AXI_WVALID));
  c6v_capture_lifecycle_0 capture_lifecycle
       (.aclk(ps7_0_FCLK_CLK0),
        .aclk_underflow(video_in_underflow),
        .available_epoch(capture_lifecycle_available_epoch),
        .available_frame_id(capture_lifecycle_available_frame_id),
        .available_slot(capture_lifecycle_available_slot),
        .axis_enable(capture_lifecycle_axis_enable),
        .capture_aresetn(capture_lifecycle_capture_aresetn),
        .capture_fault(dual_mask_capture_frame_fault),
        .capture_source_fault(capture_lifecycle_capture_source_fault),
        .cfg_frame_context(capture_control_cfg_frame_context),
        .claim_accepted(capture_lifecycle_claim_accepted),
        .closed_frame_count(capture_lifecycle_closed_frame_count),
        .common_aresetn(rst_fclk0_peripheral_aresetn),
        .control_abort_requested(capture_control_abort_requested),
        .control_armed(capture_control_armed),
        .control_barrier_request(capture_control_barrier_request),
        .control_capture_aresetn(capture_control_capture_aresetn),
        .cpu_available(capture_lifecycle_cpu_available),
        .cpu_claim(capture_control_owner_cpu_claim),
        .cpu_command_fault(capture_control_owner_command_fault),
        .cpu_epoch(capture_control_owner_cpu_epoch),
        .cpu_frame_id(capture_control_owner_cpu_frame_id),
        .cpu_held(capture_lifecycle_cpu_held),
        .cpu_release(capture_control_owner_cpu_release),
        .dma_drained(capture_write_pair_writes_drained),
        .dma_fault(capture_write_pair_status_fault),
        .epoch_sealed(capture_lifecycle_epoch_sealed),
        .fault_causes(capture_lifecycle_fault_causes),
        .frame_credit_ready(capture_lifecycle_frame_credit_ready),
        .frame_credit_request(dual_mask_capture_frame_credit_request),
        .granted_frames(capture_lifecycle_granted_frames),
        .monitor_ready(capture_lifecycle_monitor_ready),
        .owner_drained(capture_lifecycle_owner_drained),
        .owner_fault(capture_lifecycle_owner_fault),
        .owner_fault_causes(capture_lifecycle_owner_fault_causes),
        .packet_completed_frames(capture_write_pair_packet_completed_frames),
        .pipeline_drained(dual_mask_capture_pipeline_drained),
        .release_accepted(capture_lifecycle_release_accepted),
        .released_frames(capture_lifecycle_released_frames),
        .rgb_completed_frames(capture_write_pair_rgb_completed_frames),
        .source_closed(capture_lifecycle_source_closed),
        .status_completed_frames(capture_write_pair_status_completed_frames),
        .vid_active_video(vid_hsync),
        .vid_io_in_clk(vid_pclk),
        .vid_vsync(vid_vsync),
        .video_overflow(video_in_overflow));
  c6v_capture_source_fault_0 capture_source_fault
       (.aclk(ps7_0_FCLK_CLK0),
        .aclk_underflow(video_in_underflow),
        .common_aresetn(rst_fclk0_peripheral_aresetn),
        .fault_status(capture_source_fault_fault_status),
        .vid_io_in_clk(vid_pclk),
        .video_overflow(video_in_overflow));
  c6v_capture_status_0 capture_status
       (.capture_armed(capture_control_armed),
        .capture_epoch(capture_status_inputs_capture_epoch),
        .epoch_sealed(capture_lifecycle_epoch_sealed),
        .fault_causes(capture_lifecycle_fault_causes),
        .monitor_ready(capture_lifecycle_monitor_ready),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(vision_control_smc_M07_AXI_ARADDR),
        .s_axi_aresetn(skin_reset_and_Res),
        .s_axi_arready(vision_control_smc_M07_AXI_ARREADY),
        .s_axi_arvalid(vision_control_smc_M07_AXI_ARVALID),
        .s_axi_awaddr(vision_control_smc_M07_AXI_AWADDR),
        .s_axi_awready(vision_control_smc_M07_AXI_AWREADY),
        .s_axi_awvalid(vision_control_smc_M07_AXI_AWVALID),
        .s_axi_bready(vision_control_smc_M07_AXI_BREADY),
        .s_axi_bresp(vision_control_smc_M07_AXI_BRESP),
        .s_axi_bvalid(vision_control_smc_M07_AXI_BVALID),
        .s_axi_rdata(vision_control_smc_M07_AXI_RDATA),
        .s_axi_rready(vision_control_smc_M07_AXI_RREADY),
        .s_axi_rresp(vision_control_smc_M07_AXI_RRESP),
        .s_axi_rvalid(vision_control_smc_M07_AXI_RVALID),
        .s_axi_wdata(vision_control_smc_M07_AXI_WDATA),
        .s_axi_wready(vision_control_smc_M07_AXI_WREADY),
        .s_axi_wstrb(vision_control_smc_M07_AXI_WSTRB),
        .s_axi_wvalid(vision_control_smc_M07_AXI_WVALID));
  c6v_capture_status_inputs_0 capture_status_inputs
       (.capture_epoch(capture_status_inputs_capture_epoch),
        .capture_fault(capture_write_pair_status_fault),
        .frame_context(capture_control_cfg_frame_context),
        .source_fault_status(capture_source_fault_fault_status));
  c6v_capture_write_pair_0 capture_write_pair
       (.aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .capture_fault(dual_mask_capture_frame_fault),
        .closed_frame_count(capture_lifecycle_closed_frame_count),
        .packet_address(moments_dma_M_AXI_S2MM_AWADDR),
        .packet_address_length(moments_dma_M_AXI_S2MM_AWLEN),
        .packet_address_ready(moments_dma_M_AXI_S2MM_AWREADY),
        .packet_address_valid(moments_dma_M_AXI_S2MM_AWVALID),
        .packet_completed_frames(capture_write_pair_packet_completed_frames),
        .packet_data_last(moments_dma_M_AXI_S2MM_WLAST),
        .packet_data_ready(moments_dma_M_AXI_S2MM_WREADY),
        .packet_data_strobes(moments_dma_M_AXI_S2MM_WSTRB),
        .packet_data_valid(moments_dma_M_AXI_S2MM_WVALID),
        .packet_response_ready(moments_dma_M_AXI_S2MM_BREADY),
        .packet_response_status(moments_dma_M_AXI_S2MM_BRESP),
        .packet_response_valid(moments_dma_M_AXI_S2MM_BVALID),
        .packet_write_data(moments_dma_M_AXI_S2MM_WDATA),
        .rgb_address(frame_dma_M_AXI_S2MM_AWADDR),
        .rgb_address_length(frame_dma_M_AXI_S2MM_AWLEN),
        .rgb_address_ready(frame_dma_M_AXI_S2MM_AWREADY),
        .rgb_address_valid(frame_dma_M_AXI_S2MM_AWVALID),
        .rgb_completed_frames(capture_write_pair_rgb_completed_frames),
        .rgb_data_last(frame_dma_M_AXI_S2MM_WLAST),
        .rgb_data_ready(frame_dma_M_AXI_S2MM_WREADY),
        .rgb_data_strobes(frame_dma_M_AXI_S2MM_WSTRB),
        .rgb_data_valid(frame_dma_M_AXI_S2MM_WVALID),
        .rgb_response_ready(frame_dma_M_AXI_S2MM_BREADY),
        .rgb_response_status(frame_dma_M_AXI_S2MM_BRESP),
        .rgb_response_valid(frame_dma_M_AXI_S2MM_BVALID),
        .rgb_write_data(frame_dma_M_AXI_S2MM_WDATA),
        .source_closed(capture_lifecycle_source_closed),
        .status_address(moments_dma_M_AXI_SG_AWADDR),
        .status_address_burst(moments_dma_M_AXI_SG_AWBURST),
        .status_address_cache(moments_dma_M_AXI_SG_AWCACHE),
        .status_address_length(moments_dma_M_AXI_SG_AWLEN),
        .status_address_protection(moments_dma_M_AXI_SG_AWPROT),
        .status_address_ready(moments_dma_M_AXI_SG_AWREADY),
        .status_address_size(moments_dma_M_AXI_SG_AWSIZE),
        .status_address_valid(moments_dma_M_AXI_SG_AWVALID),
        .status_completed_frames(capture_write_pair_status_completed_frames),
        .status_data_last(moments_dma_M_AXI_SG_WLAST),
        .status_data_ready(moments_dma_M_AXI_SG_WREADY),
        .status_data_strobes(moments_dma_M_AXI_SG_WSTRB),
        .status_data_valid(moments_dma_M_AXI_SG_WVALID),
        .status_fault(capture_write_pair_status_fault),
        .status_read_address(moments_dma_M_AXI_SG_ARADDR),
        .status_read_address_burst(moments_dma_M_AXI_SG_ARBURST),
        .status_read_address_cache(moments_dma_M_AXI_SG_ARCACHE),
        .status_read_address_length(moments_dma_M_AXI_SG_ARLEN),
        .status_read_address_protection(moments_dma_M_AXI_SG_ARPROT),
        .status_read_address_ready(moments_dma_M_AXI_SG_ARREADY),
        .status_read_address_size(moments_dma_M_AXI_SG_ARSIZE),
        .status_read_address_valid(moments_dma_M_AXI_SG_ARVALID),
        .status_read_data(moments_dma_M_AXI_SG_RDATA),
        .status_read_last(moments_dma_M_AXI_SG_RLAST),
        .status_read_ready(moments_dma_M_AXI_SG_RREADY),
        .status_read_response(moments_dma_M_AXI_SG_RRESP),
        .status_read_valid(moments_dma_M_AXI_SG_RVALID),
        .status_response_ready(moments_dma_M_AXI_SG_BREADY),
        .status_response_status(moments_dma_M_AXI_SG_BRESP),
        .status_response_valid(moments_dma_M_AXI_SG_BVALID),
        .status_write_data(moments_dma_M_AXI_SG_WDATA),
        .writes_drained(capture_write_pair_writes_drained));
  c6v_command_read_address_gpio_0 command_read_address_gpio
       (.gpio_io_o(command_read_address_gpio_gpio_io_o),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M06_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M06_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M06_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M06_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M06_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M06_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M06_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M06_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M06_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M06_AXI_RDATA),
        .s_axi_rready(gp0_smc_M06_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M06_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M06_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M06_AXI_WDATA),
        .s_axi_wready(gp0_smc_M06_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M06_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M06_AXI_WVALID));
  c6v_command_read_data_gpio_0 command_read_data_gpio
       (.gpio2_io_i(core_debug_command_read_data_high),
        .gpio_io_i(core_debug_command_read_data_low),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M07_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M07_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M07_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M07_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M07_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M07_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M07_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M07_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M07_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M07_AXI_RDATA),
        .s_axi_rready(gp0_smc_M07_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M07_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M07_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M07_AXI_WDATA),
        .s_axi_wready(gp0_smc_M07_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M07_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M07_AXI_WVALID));
  c6v_command_status_gpio_0 command_status_gpio
       (.gpio2_io_i(core_accepted_status),
        .gpio_io_i(core_accepted_seq),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M04_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M04_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M04_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M04_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M04_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M04_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M04_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M04_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M04_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M04_AXI_RDATA),
        .s_axi_rready(gp0_smc_M04_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M04_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M04_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M04_AXI_WDATA),
        .s_axi_wready(gp0_smc_M04_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M04_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M04_AXI_WVALID));
  c6v_core_0 core
       (.accepted_packet_count(core_accepted_packet_count),
        .accepted_seq(core_accepted_seq),
        .accepted_status(core_accepted_status),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .asset_accepted_packet_count(core_asset_accepted_packet_count),
        .asset_error_flags(core_asset_error_flags),
        .asset_generation(core_asset_generation),
        .asset_rejected_packet_count(core_asset_rejected_packet_count),
        .asset_status(core_asset_status),
        .clk_pixel(pixel_clock_clk_out1),
        .debug_command_read_address(command_read_address_gpio_gpio_io_o),
        .debug_command_read_data_high(core_debug_command_read_data_high),
        .debug_command_read_data_low(core_debug_command_read_data_low),
        .framebuffer_status(core_framebuffer_status),
        .overlap_release_toggle(overlap_release_constant_dout),
        .palette_accepted_packet_count(core_palette_accepted_packet_count),
        .palette_error_flags(core_palette_error_flags),
        .palette_generation(core_palette_generation),
        .palette_rejected_packet_count(core_palette_rejected_packet_count),
        .palette_status(core_palette_status),
        .present_completed_count(core_present_completed_count),
        .present_completed_seq(core_present_completed_seq),
        .rejected_packet_count(core_rejected_packet_count),
        .render_completed_count(core_render_completed_count),
        .render_completed_seq(core_render_completed_seq),
        .render_cycles(core_render_cycles),
        .render_maximum_cycles(core_render_maximum_cycles),
        .render_status(core_render_status),
        .render_trace_crc32(core_render_trace_crc32),
        .render_write_count(core_render_write_count),
        .resetn_pixel(rst_pixel_peripheral_aresetn),
        .router_dropped_packet_count(core_router_dropped_packet_count),
        .s_axis_tdata(axi_dma_m_axis_mm2s_tdata),
        .s_axis_tkeep(axi_dma_m_axis_mm2s_tkeep),
        .s_axis_tlast(axi_dma_m_axis_mm2s_tlast),
        .s_axis_tready(core_s_axis_tready),
        .s_axis_tvalid(axi_dma_m_axis_mm2s_tvalid),
        .tilemap_accepted_packet_count(core_tilemap_accepted_packet_count),
        .tilemap_error_flags(core_tilemap_error_flags),
        .tilemap_generation(core_tilemap_generation),
        .tilemap_rejected_packet_count(core_tilemap_rejected_packet_count),
        .tilemap_status(core_tilemap_status),
        .unsupported_packet_count(core_unsupported_packet_count),
        .upload_byte_count(core_upload_byte_count),
        .upload_crc32(core_upload_crc32),
        .upload_error_flags(core_upload_error_flags),
        .upload_packet_count(core_upload_packet_count),
        .vid_data(core_vid_data),
        .vid_de(core_vid_de),
        .vid_hsync(core_vid_hsync),
        .vid_vsync(core_vid_vsync));
  c6v_demosaic_0 demosaic
       (.ap_clk(ps7_0_FCLK_CLK0),
        .ap_rst_n(rst_fclk0_peripheral_aresetn),
        .m_axis_video_TDATA(demosaic_m_axis_video_TDATA),
        .m_axis_video_TKEEP(demosaic_m_axis_video_TKEEP),
        .m_axis_video_TLAST(demosaic_m_axis_video_TLAST),
        .m_axis_video_TREADY(demosaic_m_axis_video_TREADY),
        .m_axis_video_TUSER(demosaic_m_axis_video_TUSER),
        .m_axis_video_TVALID(demosaic_m_axis_video_TVALID),
        .s_axi_CTRL_ARADDR(vision_control_smc_M01_AXI_ARADDR),
        .s_axi_CTRL_ARREADY(vision_control_smc_M01_AXI_ARREADY),
        .s_axi_CTRL_ARVALID(vision_control_smc_M01_AXI_ARVALID),
        .s_axi_CTRL_AWADDR(vision_control_smc_M01_AXI_AWADDR),
        .s_axi_CTRL_AWREADY(vision_control_smc_M01_AXI_AWREADY),
        .s_axi_CTRL_AWVALID(vision_control_smc_M01_AXI_AWVALID),
        .s_axi_CTRL_BREADY(vision_control_smc_M01_AXI_BREADY),
        .s_axi_CTRL_BRESP(vision_control_smc_M01_AXI_BRESP),
        .s_axi_CTRL_BVALID(vision_control_smc_M01_AXI_BVALID),
        .s_axi_CTRL_RDATA(vision_control_smc_M01_AXI_RDATA),
        .s_axi_CTRL_RREADY(vision_control_smc_M01_AXI_RREADY),
        .s_axi_CTRL_RRESP(vision_control_smc_M01_AXI_RRESP),
        .s_axi_CTRL_RVALID(vision_control_smc_M01_AXI_RVALID),
        .s_axi_CTRL_WDATA(vision_control_smc_M01_AXI_WDATA),
        .s_axi_CTRL_WREADY(vision_control_smc_M01_AXI_WREADY),
        .s_axi_CTRL_WSTRB(vision_control_smc_M01_AXI_WSTRB),
        .s_axi_CTRL_WVALID(vision_control_smc_M01_AXI_WVALID),
        .s_axis_video_TDATA(video_in_video_out_TDATA),
        .s_axis_video_TDEST(1'b0),
        .s_axis_video_TID(1'b0),
        .s_axis_video_TKEEP(1'b1),
        .s_axis_video_TLAST(video_in_video_out_TLAST),
        .s_axis_video_TREADY(video_in_video_out_TREADY),
        .s_axis_video_TSTRB(1'b1),
        .s_axis_video_TUSER(video_in_video_out_TUSER),
        .s_axis_video_TVALID(video_in_video_out_TVALID));
  c6v_dual_mask_capture_0 dual_mask_capture
       (.abort_requested(capture_control_abort_requested),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(capture_lifecycle_capture_aresetn),
        .cfg_frame_context(capture_control_cfg_frame_context),
        .closed_frame_count(capture_lifecycle_closed_frame_count),
        .frame_credit_ready(capture_lifecycle_frame_credit_ready),
        .frame_credit_request(dual_mask_capture_frame_credit_request),
        .frame_fault(dual_mask_capture_frame_fault),
        .m_packet_tdata(dual_mask_capture_M_PACKET_TDATA),
        .m_packet_tkeep(dual_mask_capture_M_PACKET_TKEEP),
        .m_packet_tlast(dual_mask_capture_M_PACKET_TLAST),
        .m_packet_tready(dual_mask_capture_M_PACKET_TREADY),
        .m_packet_tvalid(dual_mask_capture_M_PACKET_TVALID),
        .m_rgb_tdata(dual_mask_capture_M_RGB_TDATA),
        .m_rgb_tkeep(dual_mask_capture_M_RGB_TKEEP),
        .m_rgb_tlast(dual_mask_capture_M_RGB_TLAST),
        .m_rgb_tready(dual_mask_capture_M_RGB_TREADY),
        .m_rgb_tuser(dual_mask_capture_M_RGB_TUSER),
        .m_rgb_tvalid(dual_mask_capture_M_RGB_TVALID),
        .pipeline_drained(dual_mask_capture_pipeline_drained),
        .s_axis_tdata(demosaic_m_axis_video_TDATA),
        .s_axis_tkeep(demosaic_m_axis_video_TKEEP),
        .s_axis_tlast(demosaic_m_axis_video_TLAST),
        .s_axis_tready(demosaic_m_axis_video_TREADY),
        .s_axis_tuser(demosaic_m_axis_video_TUSER),
        .s_axis_tvalid(demosaic_m_axis_video_TVALID),
        .source_closed(capture_lifecycle_source_closed),
        .source_fault(capture_lifecycle_capture_source_fault));
  c6v_error_status_gpio_0 error_status_gpio
       (.gpio2_io_i(core_upload_error_flags),
        .gpio_io_i(core_rejected_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M05_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M05_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M05_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M05_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M05_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M05_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M05_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M05_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M05_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M05_AXI_RDATA),
        .s_axi_rready(gp0_smc_M05_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M05_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M05_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M05_AXI_WDATA),
        .s_axi_wready(gp0_smc_M05_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M05_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M05_AXI_WVALID));
  c6v_frame_dma_0 frame_dma
       (.axi_resetn(rst_fclk0_peripheral_aresetn),
        .m_axi_s2mm_aclk(ps7_0_FCLK_CLK0),
        .m_axi_s2mm_awaddr(frame_dma_M_AXI_S2MM_AWADDR),
        .m_axi_s2mm_awburst(frame_dma_M_AXI_S2MM_AWBURST),
        .m_axi_s2mm_awcache(frame_dma_M_AXI_S2MM_AWCACHE),
        .m_axi_s2mm_awlen(frame_dma_M_AXI_S2MM_AWLEN),
        .m_axi_s2mm_awprot(frame_dma_M_AXI_S2MM_AWPROT),
        .m_axi_s2mm_awready(frame_dma_M_AXI_S2MM_AWREADY),
        .m_axi_s2mm_awsize(frame_dma_M_AXI_S2MM_AWSIZE),
        .m_axi_s2mm_awvalid(frame_dma_M_AXI_S2MM_AWVALID),
        .m_axi_s2mm_bready(frame_dma_M_AXI_S2MM_BREADY),
        .m_axi_s2mm_bresp(frame_dma_M_AXI_S2MM_BRESP),
        .m_axi_s2mm_bvalid(frame_dma_M_AXI_S2MM_BVALID),
        .m_axi_s2mm_wdata(frame_dma_M_AXI_S2MM_WDATA),
        .m_axi_s2mm_wlast(frame_dma_M_AXI_S2MM_WLAST),
        .m_axi_s2mm_wready(frame_dma_M_AXI_S2MM_WREADY),
        .m_axi_s2mm_wstrb(frame_dma_M_AXI_S2MM_WSTRB),
        .m_axi_s2mm_wvalid(frame_dma_M_AXI_S2MM_WVALID),
        .s2mm_frame_ptr_in({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s2mm_introut(frame_dma_s2mm_introut),
        .s_axi_lite_aclk(ps7_0_FCLK_CLK0),
        .s_axi_lite_araddr(vision_control_smc_M02_AXI_ARADDR),
        .s_axi_lite_arready(vision_control_smc_M02_AXI_ARREADY),
        .s_axi_lite_arvalid(vision_control_smc_M02_AXI_ARVALID),
        .s_axi_lite_awaddr(vision_control_smc_M02_AXI_AWADDR),
        .s_axi_lite_awready(vision_control_smc_M02_AXI_AWREADY),
        .s_axi_lite_awvalid(vision_control_smc_M02_AXI_AWVALID),
        .s_axi_lite_bready(vision_control_smc_M02_AXI_BREADY),
        .s_axi_lite_bresp(vision_control_smc_M02_AXI_BRESP),
        .s_axi_lite_bvalid(vision_control_smc_M02_AXI_BVALID),
        .s_axi_lite_rdata(vision_control_smc_M02_AXI_RDATA),
        .s_axi_lite_rready(vision_control_smc_M02_AXI_RREADY),
        .s_axi_lite_rresp(vision_control_smc_M02_AXI_RRESP),
        .s_axi_lite_rvalid(vision_control_smc_M02_AXI_RVALID),
        .s_axi_lite_wdata(vision_control_smc_M02_AXI_WDATA),
        .s_axi_lite_wready(vision_control_smc_M02_AXI_WREADY),
        .s_axi_lite_wvalid(vision_control_smc_M02_AXI_WVALID),
        .s_axis_s2mm_aclk(ps7_0_FCLK_CLK0),
        .s_axis_s2mm_tdata(dual_mask_capture_M_RGB_TDATA),
        .s_axis_s2mm_tkeep(dual_mask_capture_M_RGB_TKEEP),
        .s_axis_s2mm_tlast(dual_mask_capture_M_RGB_TLAST),
        .s_axis_s2mm_tready(dual_mask_capture_M_RGB_TREADY),
        .s_axis_s2mm_tuser(dual_mask_capture_M_RGB_TUSER),
        .s_axis_s2mm_tvalid(dual_mask_capture_M_RGB_TVALID));
  c6v_framebuffer_status_gpio_0 framebuffer_status_gpio
       (.gpio_io_i(core_framebuffer_status),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M13_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M13_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M13_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M13_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M13_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M13_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M13_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M13_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M13_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M13_AXI_RDATA),
        .s_axi_rready(gp0_smc_M13_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M13_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M13_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M13_AXI_WDATA),
        .s_axi_wready(gp0_smc_M13_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M13_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M13_AXI_WVALID));
  c6v_gp0_smc_0 gp0_smc
       (.M00_AXI_araddr(gp0_smc_M00_AXI_ARADDR),
        .M00_AXI_arready(gp0_smc_M00_AXI_ARREADY),
        .M00_AXI_arvalid(gp0_smc_M00_AXI_ARVALID),
        .M00_AXI_awaddr(gp0_smc_M00_AXI_AWADDR),
        .M00_AXI_awready(gp0_smc_M00_AXI_AWREADY),
        .M00_AXI_awvalid(gp0_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(gp0_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(gp0_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(gp0_smc_M00_AXI_BVALID),
        .M00_AXI_rdata(gp0_smc_M00_AXI_RDATA),
        .M00_AXI_rready(gp0_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(gp0_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(gp0_smc_M00_AXI_RVALID),
        .M00_AXI_wdata(gp0_smc_M00_AXI_WDATA),
        .M00_AXI_wready(gp0_smc_M00_AXI_WREADY),
        .M00_AXI_wvalid(gp0_smc_M00_AXI_WVALID),
        .M01_AXI_araddr(gp0_smc_M01_AXI_ARADDR),
        .M01_AXI_arready(gp0_smc_M01_AXI_ARREADY),
        .M01_AXI_arvalid(gp0_smc_M01_AXI_ARVALID),
        .M01_AXI_awaddr(gp0_smc_M01_AXI_AWADDR),
        .M01_AXI_awready(gp0_smc_M01_AXI_AWREADY),
        .M01_AXI_awvalid(gp0_smc_M01_AXI_AWVALID),
        .M01_AXI_bready(gp0_smc_M01_AXI_BREADY),
        .M01_AXI_bresp(gp0_smc_M01_AXI_BRESP),
        .M01_AXI_bvalid(gp0_smc_M01_AXI_BVALID),
        .M01_AXI_rdata(gp0_smc_M01_AXI_RDATA),
        .M01_AXI_rready(gp0_smc_M01_AXI_RREADY),
        .M01_AXI_rresp(gp0_smc_M01_AXI_RRESP),
        .M01_AXI_rvalid(gp0_smc_M01_AXI_RVALID),
        .M01_AXI_wdata(gp0_smc_M01_AXI_WDATA),
        .M01_AXI_wready(gp0_smc_M01_AXI_WREADY),
        .M01_AXI_wstrb(gp0_smc_M01_AXI_WSTRB),
        .M01_AXI_wvalid(gp0_smc_M01_AXI_WVALID),
        .M02_AXI_araddr(gp0_smc_M02_AXI_ARADDR),
        .M02_AXI_arready(gp0_smc_M02_AXI_ARREADY),
        .M02_AXI_arvalid(gp0_smc_M02_AXI_ARVALID),
        .M02_AXI_awaddr(gp0_smc_M02_AXI_AWADDR),
        .M02_AXI_awready(gp0_smc_M02_AXI_AWREADY),
        .M02_AXI_awvalid(gp0_smc_M02_AXI_AWVALID),
        .M02_AXI_bready(gp0_smc_M02_AXI_BREADY),
        .M02_AXI_bresp(gp0_smc_M02_AXI_BRESP),
        .M02_AXI_bvalid(gp0_smc_M02_AXI_BVALID),
        .M02_AXI_rdata(gp0_smc_M02_AXI_RDATA),
        .M02_AXI_rready(gp0_smc_M02_AXI_RREADY),
        .M02_AXI_rresp(gp0_smc_M02_AXI_RRESP),
        .M02_AXI_rvalid(gp0_smc_M02_AXI_RVALID),
        .M02_AXI_wdata(gp0_smc_M02_AXI_WDATA),
        .M02_AXI_wready(gp0_smc_M02_AXI_WREADY),
        .M02_AXI_wstrb(gp0_smc_M02_AXI_WSTRB),
        .M02_AXI_wvalid(gp0_smc_M02_AXI_WVALID),
        .M03_AXI_araddr(gp0_smc_M03_AXI_ARADDR),
        .M03_AXI_arready(gp0_smc_M03_AXI_ARREADY),
        .M03_AXI_arvalid(gp0_smc_M03_AXI_ARVALID),
        .M03_AXI_awaddr(gp0_smc_M03_AXI_AWADDR),
        .M03_AXI_awready(gp0_smc_M03_AXI_AWREADY),
        .M03_AXI_awvalid(gp0_smc_M03_AXI_AWVALID),
        .M03_AXI_bready(gp0_smc_M03_AXI_BREADY),
        .M03_AXI_bresp(gp0_smc_M03_AXI_BRESP),
        .M03_AXI_bvalid(gp0_smc_M03_AXI_BVALID),
        .M03_AXI_rdata(gp0_smc_M03_AXI_RDATA),
        .M03_AXI_rready(gp0_smc_M03_AXI_RREADY),
        .M03_AXI_rresp(gp0_smc_M03_AXI_RRESP),
        .M03_AXI_rvalid(gp0_smc_M03_AXI_RVALID),
        .M03_AXI_wdata(gp0_smc_M03_AXI_WDATA),
        .M03_AXI_wready(gp0_smc_M03_AXI_WREADY),
        .M03_AXI_wstrb(gp0_smc_M03_AXI_WSTRB),
        .M03_AXI_wvalid(gp0_smc_M03_AXI_WVALID),
        .M04_AXI_araddr(gp0_smc_M04_AXI_ARADDR),
        .M04_AXI_arready(gp0_smc_M04_AXI_ARREADY),
        .M04_AXI_arvalid(gp0_smc_M04_AXI_ARVALID),
        .M04_AXI_awaddr(gp0_smc_M04_AXI_AWADDR),
        .M04_AXI_awready(gp0_smc_M04_AXI_AWREADY),
        .M04_AXI_awvalid(gp0_smc_M04_AXI_AWVALID),
        .M04_AXI_bready(gp0_smc_M04_AXI_BREADY),
        .M04_AXI_bresp(gp0_smc_M04_AXI_BRESP),
        .M04_AXI_bvalid(gp0_smc_M04_AXI_BVALID),
        .M04_AXI_rdata(gp0_smc_M04_AXI_RDATA),
        .M04_AXI_rready(gp0_smc_M04_AXI_RREADY),
        .M04_AXI_rresp(gp0_smc_M04_AXI_RRESP),
        .M04_AXI_rvalid(gp0_smc_M04_AXI_RVALID),
        .M04_AXI_wdata(gp0_smc_M04_AXI_WDATA),
        .M04_AXI_wready(gp0_smc_M04_AXI_WREADY),
        .M04_AXI_wstrb(gp0_smc_M04_AXI_WSTRB),
        .M04_AXI_wvalid(gp0_smc_M04_AXI_WVALID),
        .M05_AXI_araddr(gp0_smc_M05_AXI_ARADDR),
        .M05_AXI_arready(gp0_smc_M05_AXI_ARREADY),
        .M05_AXI_arvalid(gp0_smc_M05_AXI_ARVALID),
        .M05_AXI_awaddr(gp0_smc_M05_AXI_AWADDR),
        .M05_AXI_awready(gp0_smc_M05_AXI_AWREADY),
        .M05_AXI_awvalid(gp0_smc_M05_AXI_AWVALID),
        .M05_AXI_bready(gp0_smc_M05_AXI_BREADY),
        .M05_AXI_bresp(gp0_smc_M05_AXI_BRESP),
        .M05_AXI_bvalid(gp0_smc_M05_AXI_BVALID),
        .M05_AXI_rdata(gp0_smc_M05_AXI_RDATA),
        .M05_AXI_rready(gp0_smc_M05_AXI_RREADY),
        .M05_AXI_rresp(gp0_smc_M05_AXI_RRESP),
        .M05_AXI_rvalid(gp0_smc_M05_AXI_RVALID),
        .M05_AXI_wdata(gp0_smc_M05_AXI_WDATA),
        .M05_AXI_wready(gp0_smc_M05_AXI_WREADY),
        .M05_AXI_wstrb(gp0_smc_M05_AXI_WSTRB),
        .M05_AXI_wvalid(gp0_smc_M05_AXI_WVALID),
        .M06_AXI_araddr(gp0_smc_M06_AXI_ARADDR),
        .M06_AXI_arready(gp0_smc_M06_AXI_ARREADY),
        .M06_AXI_arvalid(gp0_smc_M06_AXI_ARVALID),
        .M06_AXI_awaddr(gp0_smc_M06_AXI_AWADDR),
        .M06_AXI_awready(gp0_smc_M06_AXI_AWREADY),
        .M06_AXI_awvalid(gp0_smc_M06_AXI_AWVALID),
        .M06_AXI_bready(gp0_smc_M06_AXI_BREADY),
        .M06_AXI_bresp(gp0_smc_M06_AXI_BRESP),
        .M06_AXI_bvalid(gp0_smc_M06_AXI_BVALID),
        .M06_AXI_rdata(gp0_smc_M06_AXI_RDATA),
        .M06_AXI_rready(gp0_smc_M06_AXI_RREADY),
        .M06_AXI_rresp(gp0_smc_M06_AXI_RRESP),
        .M06_AXI_rvalid(gp0_smc_M06_AXI_RVALID),
        .M06_AXI_wdata(gp0_smc_M06_AXI_WDATA),
        .M06_AXI_wready(gp0_smc_M06_AXI_WREADY),
        .M06_AXI_wstrb(gp0_smc_M06_AXI_WSTRB),
        .M06_AXI_wvalid(gp0_smc_M06_AXI_WVALID),
        .M07_AXI_araddr(gp0_smc_M07_AXI_ARADDR),
        .M07_AXI_arready(gp0_smc_M07_AXI_ARREADY),
        .M07_AXI_arvalid(gp0_smc_M07_AXI_ARVALID),
        .M07_AXI_awaddr(gp0_smc_M07_AXI_AWADDR),
        .M07_AXI_awready(gp0_smc_M07_AXI_AWREADY),
        .M07_AXI_awvalid(gp0_smc_M07_AXI_AWVALID),
        .M07_AXI_bready(gp0_smc_M07_AXI_BREADY),
        .M07_AXI_bresp(gp0_smc_M07_AXI_BRESP),
        .M07_AXI_bvalid(gp0_smc_M07_AXI_BVALID),
        .M07_AXI_rdata(gp0_smc_M07_AXI_RDATA),
        .M07_AXI_rready(gp0_smc_M07_AXI_RREADY),
        .M07_AXI_rresp(gp0_smc_M07_AXI_RRESP),
        .M07_AXI_rvalid(gp0_smc_M07_AXI_RVALID),
        .M07_AXI_wdata(gp0_smc_M07_AXI_WDATA),
        .M07_AXI_wready(gp0_smc_M07_AXI_WREADY),
        .M07_AXI_wstrb(gp0_smc_M07_AXI_WSTRB),
        .M07_AXI_wvalid(gp0_smc_M07_AXI_WVALID),
        .M08_AXI_araddr(gp0_smc_M08_AXI_ARADDR),
        .M08_AXI_arready(gp0_smc_M08_AXI_ARREADY),
        .M08_AXI_arvalid(gp0_smc_M08_AXI_ARVALID),
        .M08_AXI_awaddr(gp0_smc_M08_AXI_AWADDR),
        .M08_AXI_awready(gp0_smc_M08_AXI_AWREADY),
        .M08_AXI_awvalid(gp0_smc_M08_AXI_AWVALID),
        .M08_AXI_bready(gp0_smc_M08_AXI_BREADY),
        .M08_AXI_bresp(gp0_smc_M08_AXI_BRESP),
        .M08_AXI_bvalid(gp0_smc_M08_AXI_BVALID),
        .M08_AXI_rdata(gp0_smc_M08_AXI_RDATA),
        .M08_AXI_rready(gp0_smc_M08_AXI_RREADY),
        .M08_AXI_rresp(gp0_smc_M08_AXI_RRESP),
        .M08_AXI_rvalid(gp0_smc_M08_AXI_RVALID),
        .M08_AXI_wdata(gp0_smc_M08_AXI_WDATA),
        .M08_AXI_wready(gp0_smc_M08_AXI_WREADY),
        .M08_AXI_wstrb(gp0_smc_M08_AXI_WSTRB),
        .M08_AXI_wvalid(gp0_smc_M08_AXI_WVALID),
        .M09_AXI_araddr(gp0_smc_M09_AXI_ARADDR),
        .M09_AXI_arready(gp0_smc_M09_AXI_ARREADY),
        .M09_AXI_arvalid(gp0_smc_M09_AXI_ARVALID),
        .M09_AXI_awaddr(gp0_smc_M09_AXI_AWADDR),
        .M09_AXI_awready(gp0_smc_M09_AXI_AWREADY),
        .M09_AXI_awvalid(gp0_smc_M09_AXI_AWVALID),
        .M09_AXI_bready(gp0_smc_M09_AXI_BREADY),
        .M09_AXI_bresp(gp0_smc_M09_AXI_BRESP),
        .M09_AXI_bvalid(gp0_smc_M09_AXI_BVALID),
        .M09_AXI_rdata(gp0_smc_M09_AXI_RDATA),
        .M09_AXI_rready(gp0_smc_M09_AXI_RREADY),
        .M09_AXI_rresp(gp0_smc_M09_AXI_RRESP),
        .M09_AXI_rvalid(gp0_smc_M09_AXI_RVALID),
        .M09_AXI_wdata(gp0_smc_M09_AXI_WDATA),
        .M09_AXI_wready(gp0_smc_M09_AXI_WREADY),
        .M09_AXI_wstrb(gp0_smc_M09_AXI_WSTRB),
        .M09_AXI_wvalid(gp0_smc_M09_AXI_WVALID),
        .M10_AXI_araddr(gp0_smc_M10_AXI_ARADDR),
        .M10_AXI_arready(gp0_smc_M10_AXI_ARREADY),
        .M10_AXI_arvalid(gp0_smc_M10_AXI_ARVALID),
        .M10_AXI_awaddr(gp0_smc_M10_AXI_AWADDR),
        .M10_AXI_awready(gp0_smc_M10_AXI_AWREADY),
        .M10_AXI_awvalid(gp0_smc_M10_AXI_AWVALID),
        .M10_AXI_bready(gp0_smc_M10_AXI_BREADY),
        .M10_AXI_bresp(gp0_smc_M10_AXI_BRESP),
        .M10_AXI_bvalid(gp0_smc_M10_AXI_BVALID),
        .M10_AXI_rdata(gp0_smc_M10_AXI_RDATA),
        .M10_AXI_rready(gp0_smc_M10_AXI_RREADY),
        .M10_AXI_rresp(gp0_smc_M10_AXI_RRESP),
        .M10_AXI_rvalid(gp0_smc_M10_AXI_RVALID),
        .M10_AXI_wdata(gp0_smc_M10_AXI_WDATA),
        .M10_AXI_wready(gp0_smc_M10_AXI_WREADY),
        .M10_AXI_wstrb(gp0_smc_M10_AXI_WSTRB),
        .M10_AXI_wvalid(gp0_smc_M10_AXI_WVALID),
        .M11_AXI_araddr(gp0_smc_M11_AXI_ARADDR),
        .M11_AXI_arready(gp0_smc_M11_AXI_ARREADY),
        .M11_AXI_arvalid(gp0_smc_M11_AXI_ARVALID),
        .M11_AXI_awaddr(gp0_smc_M11_AXI_AWADDR),
        .M11_AXI_awready(gp0_smc_M11_AXI_AWREADY),
        .M11_AXI_awvalid(gp0_smc_M11_AXI_AWVALID),
        .M11_AXI_bready(gp0_smc_M11_AXI_BREADY),
        .M11_AXI_bresp(gp0_smc_M11_AXI_BRESP),
        .M11_AXI_bvalid(gp0_smc_M11_AXI_BVALID),
        .M11_AXI_rdata(gp0_smc_M11_AXI_RDATA),
        .M11_AXI_rready(gp0_smc_M11_AXI_RREADY),
        .M11_AXI_rresp(gp0_smc_M11_AXI_RRESP),
        .M11_AXI_rvalid(gp0_smc_M11_AXI_RVALID),
        .M11_AXI_wdata(gp0_smc_M11_AXI_WDATA),
        .M11_AXI_wready(gp0_smc_M11_AXI_WREADY),
        .M11_AXI_wstrb(gp0_smc_M11_AXI_WSTRB),
        .M11_AXI_wvalid(gp0_smc_M11_AXI_WVALID),
        .M12_AXI_araddr(gp0_smc_M12_AXI_ARADDR),
        .M12_AXI_arready(gp0_smc_M12_AXI_ARREADY),
        .M12_AXI_arvalid(gp0_smc_M12_AXI_ARVALID),
        .M12_AXI_awaddr(gp0_smc_M12_AXI_AWADDR),
        .M12_AXI_awready(gp0_smc_M12_AXI_AWREADY),
        .M12_AXI_awvalid(gp0_smc_M12_AXI_AWVALID),
        .M12_AXI_bready(gp0_smc_M12_AXI_BREADY),
        .M12_AXI_bresp(gp0_smc_M12_AXI_BRESP),
        .M12_AXI_bvalid(gp0_smc_M12_AXI_BVALID),
        .M12_AXI_rdata(gp0_smc_M12_AXI_RDATA),
        .M12_AXI_rready(gp0_smc_M12_AXI_RREADY),
        .M12_AXI_rresp(gp0_smc_M12_AXI_RRESP),
        .M12_AXI_rvalid(gp0_smc_M12_AXI_RVALID),
        .M12_AXI_wdata(gp0_smc_M12_AXI_WDATA),
        .M12_AXI_wready(gp0_smc_M12_AXI_WREADY),
        .M12_AXI_wstrb(gp0_smc_M12_AXI_WSTRB),
        .M12_AXI_wvalid(gp0_smc_M12_AXI_WVALID),
        .M13_AXI_araddr(gp0_smc_M13_AXI_ARADDR),
        .M13_AXI_arready(gp0_smc_M13_AXI_ARREADY),
        .M13_AXI_arvalid(gp0_smc_M13_AXI_ARVALID),
        .M13_AXI_awaddr(gp0_smc_M13_AXI_AWADDR),
        .M13_AXI_awready(gp0_smc_M13_AXI_AWREADY),
        .M13_AXI_awvalid(gp0_smc_M13_AXI_AWVALID),
        .M13_AXI_bready(gp0_smc_M13_AXI_BREADY),
        .M13_AXI_bresp(gp0_smc_M13_AXI_BRESP),
        .M13_AXI_bvalid(gp0_smc_M13_AXI_BVALID),
        .M13_AXI_rdata(gp0_smc_M13_AXI_RDATA),
        .M13_AXI_rready(gp0_smc_M13_AXI_RREADY),
        .M13_AXI_rresp(gp0_smc_M13_AXI_RRESP),
        .M13_AXI_rvalid(gp0_smc_M13_AXI_RVALID),
        .M13_AXI_wdata(gp0_smc_M13_AXI_WDATA),
        .M13_AXI_wready(gp0_smc_M13_AXI_WREADY),
        .M13_AXI_wstrb(gp0_smc_M13_AXI_WSTRB),
        .M13_AXI_wvalid(gp0_smc_M13_AXI_WVALID),
        .M14_AXI_araddr(gp0_smc_M14_AXI_ARADDR),
        .M14_AXI_arready(gp0_smc_M14_AXI_ARREADY),
        .M14_AXI_arvalid(gp0_smc_M14_AXI_ARVALID),
        .M14_AXI_awaddr(gp0_smc_M14_AXI_AWADDR),
        .M14_AXI_awready(gp0_smc_M14_AXI_AWREADY),
        .M14_AXI_awvalid(gp0_smc_M14_AXI_AWVALID),
        .M14_AXI_bready(gp0_smc_M14_AXI_BREADY),
        .M14_AXI_bresp(gp0_smc_M14_AXI_BRESP),
        .M14_AXI_bvalid(gp0_smc_M14_AXI_BVALID),
        .M14_AXI_rdata(gp0_smc_M14_AXI_RDATA),
        .M14_AXI_rready(gp0_smc_M14_AXI_RREADY),
        .M14_AXI_rresp(gp0_smc_M14_AXI_RRESP),
        .M14_AXI_rvalid(gp0_smc_M14_AXI_RVALID),
        .M14_AXI_wdata(gp0_smc_M14_AXI_WDATA),
        .M14_AXI_wready(gp0_smc_M14_AXI_WREADY),
        .M14_AXI_wstrb(gp0_smc_M14_AXI_WSTRB),
        .M14_AXI_wvalid(gp0_smc_M14_AXI_WVALID),
        .M15_AXI_araddr(gp0_smc_M15_AXI_ARADDR),
        .M15_AXI_arready(gp0_smc_M15_AXI_ARREADY),
        .M15_AXI_arvalid(gp0_smc_M15_AXI_ARVALID),
        .M15_AXI_awaddr(gp0_smc_M15_AXI_AWADDR),
        .M15_AXI_awready(gp0_smc_M15_AXI_AWREADY),
        .M15_AXI_awvalid(gp0_smc_M15_AXI_AWVALID),
        .M15_AXI_bready(gp0_smc_M15_AXI_BREADY),
        .M15_AXI_bresp(gp0_smc_M15_AXI_BRESP),
        .M15_AXI_bvalid(gp0_smc_M15_AXI_BVALID),
        .M15_AXI_rdata(gp0_smc_M15_AXI_RDATA),
        .M15_AXI_rready(gp0_smc_M15_AXI_RREADY),
        .M15_AXI_rresp(gp0_smc_M15_AXI_RRESP),
        .M15_AXI_rvalid(gp0_smc_M15_AXI_RVALID),
        .M15_AXI_wdata(gp0_smc_M15_AXI_WDATA),
        .M15_AXI_wready(gp0_smc_M15_AXI_WREADY),
        .M15_AXI_wstrb(gp0_smc_M15_AXI_WSTRB),
        .M15_AXI_wvalid(gp0_smc_M15_AXI_WVALID),
        .M16_AXI_araddr(gp0_smc_M16_AXI_ARADDR),
        .M16_AXI_arready(gp0_smc_M16_AXI_ARREADY),
        .M16_AXI_arvalid(gp0_smc_M16_AXI_ARVALID),
        .M16_AXI_awaddr(gp0_smc_M16_AXI_AWADDR),
        .M16_AXI_awready(gp0_smc_M16_AXI_AWREADY),
        .M16_AXI_awvalid(gp0_smc_M16_AXI_AWVALID),
        .M16_AXI_bready(gp0_smc_M16_AXI_BREADY),
        .M16_AXI_bresp(gp0_smc_M16_AXI_BRESP),
        .M16_AXI_bvalid(gp0_smc_M16_AXI_BVALID),
        .M16_AXI_rdata(gp0_smc_M16_AXI_RDATA),
        .M16_AXI_rready(gp0_smc_M16_AXI_RREADY),
        .M16_AXI_rresp(gp0_smc_M16_AXI_RRESP),
        .M16_AXI_rvalid(gp0_smc_M16_AXI_RVALID),
        .M16_AXI_wdata(gp0_smc_M16_AXI_WDATA),
        .M16_AXI_wready(gp0_smc_M16_AXI_WREADY),
        .M16_AXI_wstrb(gp0_smc_M16_AXI_WSTRB),
        .M16_AXI_wvalid(gp0_smc_M16_AXI_WVALID),
        .M17_AXI_araddr(gp0_smc_M17_AXI_ARADDR),
        .M17_AXI_arready(gp0_smc_M17_AXI_ARREADY),
        .M17_AXI_arvalid(gp0_smc_M17_AXI_ARVALID),
        .M17_AXI_awaddr(gp0_smc_M17_AXI_AWADDR),
        .M17_AXI_awready(gp0_smc_M17_AXI_AWREADY),
        .M17_AXI_awvalid(gp0_smc_M17_AXI_AWVALID),
        .M17_AXI_bready(gp0_smc_M17_AXI_BREADY),
        .M17_AXI_bresp(gp0_smc_M17_AXI_BRESP),
        .M17_AXI_bvalid(gp0_smc_M17_AXI_BVALID),
        .M17_AXI_rdata(gp0_smc_M17_AXI_RDATA),
        .M17_AXI_rready(gp0_smc_M17_AXI_RREADY),
        .M17_AXI_rresp(gp0_smc_M17_AXI_RRESP),
        .M17_AXI_rvalid(gp0_smc_M17_AXI_RVALID),
        .M17_AXI_wdata(gp0_smc_M17_AXI_WDATA),
        .M17_AXI_wready(gp0_smc_M17_AXI_WREADY),
        .M17_AXI_wstrb(gp0_smc_M17_AXI_WSTRB),
        .M17_AXI_wvalid(gp0_smc_M17_AXI_WVALID),
        .M18_AXI_araddr(gp0_smc_M18_AXI_ARADDR),
        .M18_AXI_arready(gp0_smc_M18_AXI_ARREADY),
        .M18_AXI_arvalid(gp0_smc_M18_AXI_ARVALID),
        .M18_AXI_awaddr(gp0_smc_M18_AXI_AWADDR),
        .M18_AXI_awready(gp0_smc_M18_AXI_AWREADY),
        .M18_AXI_awvalid(gp0_smc_M18_AXI_AWVALID),
        .M18_AXI_bready(gp0_smc_M18_AXI_BREADY),
        .M18_AXI_bresp(gp0_smc_M18_AXI_BRESP),
        .M18_AXI_bvalid(gp0_smc_M18_AXI_BVALID),
        .M18_AXI_rdata(gp0_smc_M18_AXI_RDATA),
        .M18_AXI_rready(gp0_smc_M18_AXI_RREADY),
        .M18_AXI_rresp(gp0_smc_M18_AXI_RRESP),
        .M18_AXI_rvalid(gp0_smc_M18_AXI_RVALID),
        .M18_AXI_wdata(gp0_smc_M18_AXI_WDATA),
        .M18_AXI_wready(gp0_smc_M18_AXI_WREADY),
        .M18_AXI_wstrb(gp0_smc_M18_AXI_WSTRB),
        .M18_AXI_wvalid(gp0_smc_M18_AXI_WVALID),
        .M19_AXI_araddr(gp0_smc_M19_AXI_ARADDR),
        .M19_AXI_arready(gp0_smc_M19_AXI_ARREADY),
        .M19_AXI_arvalid(gp0_smc_M19_AXI_ARVALID),
        .M19_AXI_awaddr(gp0_smc_M19_AXI_AWADDR),
        .M19_AXI_awready(gp0_smc_M19_AXI_AWREADY),
        .M19_AXI_awvalid(gp0_smc_M19_AXI_AWVALID),
        .M19_AXI_bready(gp0_smc_M19_AXI_BREADY),
        .M19_AXI_bresp(gp0_smc_M19_AXI_BRESP),
        .M19_AXI_bvalid(gp0_smc_M19_AXI_BVALID),
        .M19_AXI_rdata(gp0_smc_M19_AXI_RDATA),
        .M19_AXI_rready(gp0_smc_M19_AXI_RREADY),
        .M19_AXI_rresp(gp0_smc_M19_AXI_RRESP),
        .M19_AXI_rvalid(gp0_smc_M19_AXI_RVALID),
        .M19_AXI_wdata(gp0_smc_M19_AXI_WDATA),
        .M19_AXI_wready(gp0_smc_M19_AXI_WREADY),
        .M19_AXI_wstrb(gp0_smc_M19_AXI_WSTRB),
        .M19_AXI_wvalid(gp0_smc_M19_AXI_WVALID),
        .M20_AXI_araddr(gp0_smc_M20_AXI_ARADDR),
        .M20_AXI_arready(gp0_smc_M20_AXI_ARREADY),
        .M20_AXI_arvalid(gp0_smc_M20_AXI_ARVALID),
        .M20_AXI_awaddr(gp0_smc_M20_AXI_AWADDR),
        .M20_AXI_awready(gp0_smc_M20_AXI_AWREADY),
        .M20_AXI_awvalid(gp0_smc_M20_AXI_AWVALID),
        .M20_AXI_bready(gp0_smc_M20_AXI_BREADY),
        .M20_AXI_bresp(gp0_smc_M20_AXI_BRESP),
        .M20_AXI_bvalid(gp0_smc_M20_AXI_BVALID),
        .M20_AXI_rdata(gp0_smc_M20_AXI_RDATA),
        .M20_AXI_rready(gp0_smc_M20_AXI_RREADY),
        .M20_AXI_rresp(gp0_smc_M20_AXI_RRESP),
        .M20_AXI_rvalid(gp0_smc_M20_AXI_RVALID),
        .M20_AXI_wdata(gp0_smc_M20_AXI_WDATA),
        .M20_AXI_wready(gp0_smc_M20_AXI_WREADY),
        .M20_AXI_wstrb(gp0_smc_M20_AXI_WSTRB),
        .M20_AXI_wvalid(gp0_smc_M20_AXI_WVALID),
        .M21_AXI_araddr(gp0_smc_M21_AXI_ARADDR),
        .M21_AXI_arready(gp0_smc_M21_AXI_ARREADY),
        .M21_AXI_arvalid(gp0_smc_M21_AXI_ARVALID),
        .M21_AXI_awaddr(gp0_smc_M21_AXI_AWADDR),
        .M21_AXI_awready(gp0_smc_M21_AXI_AWREADY),
        .M21_AXI_awvalid(gp0_smc_M21_AXI_AWVALID),
        .M21_AXI_bready(gp0_smc_M21_AXI_BREADY),
        .M21_AXI_bresp(gp0_smc_M21_AXI_BRESP),
        .M21_AXI_bvalid(gp0_smc_M21_AXI_BVALID),
        .M21_AXI_rdata(gp0_smc_M21_AXI_RDATA),
        .M21_AXI_rready(gp0_smc_M21_AXI_RREADY),
        .M21_AXI_rresp(gp0_smc_M21_AXI_RRESP),
        .M21_AXI_rvalid(gp0_smc_M21_AXI_RVALID),
        .M21_AXI_wdata(gp0_smc_M21_AXI_WDATA),
        .M21_AXI_wready(gp0_smc_M21_AXI_WREADY),
        .M21_AXI_wstrb(gp0_smc_M21_AXI_WSTRB),
        .M21_AXI_wvalid(gp0_smc_M21_AXI_WVALID),
        .M22_AXI_araddr(gp0_smc_M22_AXI_ARADDR),
        .M22_AXI_arready(gp0_smc_M22_AXI_ARREADY),
        .M22_AXI_arvalid(gp0_smc_M22_AXI_ARVALID),
        .M22_AXI_awaddr(gp0_smc_M22_AXI_AWADDR),
        .M22_AXI_awready(gp0_smc_M22_AXI_AWREADY),
        .M22_AXI_awvalid(gp0_smc_M22_AXI_AWVALID),
        .M22_AXI_bready(gp0_smc_M22_AXI_BREADY),
        .M22_AXI_bresp(gp0_smc_M22_AXI_BRESP),
        .M22_AXI_bvalid(gp0_smc_M22_AXI_BVALID),
        .M22_AXI_rdata(gp0_smc_M22_AXI_RDATA),
        .M22_AXI_rready(gp0_smc_M22_AXI_RREADY),
        .M22_AXI_rresp(gp0_smc_M22_AXI_RRESP),
        .M22_AXI_rvalid(gp0_smc_M22_AXI_RVALID),
        .M22_AXI_wdata(gp0_smc_M22_AXI_WDATA),
        .M22_AXI_wready(gp0_smc_M22_AXI_WREADY),
        .M22_AXI_wstrb(gp0_smc_M22_AXI_WSTRB),
        .M22_AXI_wvalid(gp0_smc_M22_AXI_WVALID),
        .M23_AXI_araddr(gp0_smc_M23_AXI_ARADDR),
        .M23_AXI_arready(gp0_smc_M23_AXI_ARREADY),
        .M23_AXI_arvalid(gp0_smc_M23_AXI_ARVALID),
        .M23_AXI_awaddr(gp0_smc_M23_AXI_AWADDR),
        .M23_AXI_awready(gp0_smc_M23_AXI_AWREADY),
        .M23_AXI_awvalid(gp0_smc_M23_AXI_AWVALID),
        .M23_AXI_bready(gp0_smc_M23_AXI_BREADY),
        .M23_AXI_bresp(gp0_smc_M23_AXI_BRESP),
        .M23_AXI_bvalid(gp0_smc_M23_AXI_BVALID),
        .M23_AXI_rdata(gp0_smc_M23_AXI_RDATA),
        .M23_AXI_rready(gp0_smc_M23_AXI_RREADY),
        .M23_AXI_rresp(gp0_smc_M23_AXI_RRESP),
        .M23_AXI_rvalid(gp0_smc_M23_AXI_RVALID),
        .M23_AXI_wdata(gp0_smc_M23_AXI_WDATA),
        .M23_AXI_wready(gp0_smc_M23_AXI_WREADY),
        .M23_AXI_wstrb(gp0_smc_M23_AXI_WSTRB),
        .M23_AXI_wvalid(gp0_smc_M23_AXI_WVALID),
        .M24_AXI_araddr(gp0_smc_M24_AXI_ARADDR),
        .M24_AXI_arready(gp0_smc_M24_AXI_ARREADY),
        .M24_AXI_arvalid(gp0_smc_M24_AXI_ARVALID),
        .M24_AXI_awaddr(gp0_smc_M24_AXI_AWADDR),
        .M24_AXI_awready(gp0_smc_M24_AXI_AWREADY),
        .M24_AXI_awvalid(gp0_smc_M24_AXI_AWVALID),
        .M24_AXI_bready(gp0_smc_M24_AXI_BREADY),
        .M24_AXI_bresp(gp0_smc_M24_AXI_BRESP),
        .M24_AXI_bvalid(gp0_smc_M24_AXI_BVALID),
        .M24_AXI_rdata(gp0_smc_M24_AXI_RDATA),
        .M24_AXI_rready(gp0_smc_M24_AXI_RREADY),
        .M24_AXI_rresp(gp0_smc_M24_AXI_RRESP),
        .M24_AXI_rvalid(gp0_smc_M24_AXI_RVALID),
        .M24_AXI_wdata(gp0_smc_M24_AXI_WDATA),
        .M24_AXI_wready(gp0_smc_M24_AXI_WREADY),
        .M24_AXI_wvalid(gp0_smc_M24_AXI_WVALID),
        .M25_AXI_araddr(gp0_smc_M25_AXI_ARADDR),
        .M25_AXI_arready(gp0_smc_M25_AXI_ARREADY),
        .M25_AXI_arvalid(gp0_smc_M25_AXI_ARVALID),
        .M25_AXI_awaddr(gp0_smc_M25_AXI_AWADDR),
        .M25_AXI_awready(gp0_smc_M25_AXI_AWREADY),
        .M25_AXI_awvalid(gp0_smc_M25_AXI_AWVALID),
        .M25_AXI_bready(gp0_smc_M25_AXI_BREADY),
        .M25_AXI_bresp(gp0_smc_M25_AXI_BRESP),
        .M25_AXI_bvalid(gp0_smc_M25_AXI_BVALID),
        .M25_AXI_rdata(gp0_smc_M25_AXI_RDATA),
        .M25_AXI_rready(gp0_smc_M25_AXI_RREADY),
        .M25_AXI_rresp(gp0_smc_M25_AXI_RRESP),
        .M25_AXI_rvalid(gp0_smc_M25_AXI_RVALID),
        .M25_AXI_wdata(gp0_smc_M25_AXI_WDATA),
        .M25_AXI_wready(gp0_smc_M25_AXI_WREADY),
        .M25_AXI_wstrb(gp0_smc_M25_AXI_WSTRB),
        .M25_AXI_wvalid(gp0_smc_M25_AXI_WVALID),
        .M26_AXI_araddr(gp0_smc_M26_AXI_ARADDR),
        .M26_AXI_arready(gp0_smc_M26_AXI_ARREADY),
        .M26_AXI_arvalid(gp0_smc_M26_AXI_ARVALID),
        .M26_AXI_awaddr(gp0_smc_M26_AXI_AWADDR),
        .M26_AXI_awready(gp0_smc_M26_AXI_AWREADY),
        .M26_AXI_awvalid(gp0_smc_M26_AXI_AWVALID),
        .M26_AXI_bready(gp0_smc_M26_AXI_BREADY),
        .M26_AXI_bresp(gp0_smc_M26_AXI_BRESP),
        .M26_AXI_bvalid(gp0_smc_M26_AXI_BVALID),
        .M26_AXI_rdata(gp0_smc_M26_AXI_RDATA),
        .M26_AXI_rready(gp0_smc_M26_AXI_RREADY),
        .M26_AXI_rresp(gp0_smc_M26_AXI_RRESP),
        .M26_AXI_rvalid(gp0_smc_M26_AXI_RVALID),
        .M26_AXI_wdata(gp0_smc_M26_AXI_WDATA),
        .M26_AXI_wready(gp0_smc_M26_AXI_WREADY),
        .M26_AXI_wstrb(gp0_smc_M26_AXI_WSTRB),
        .M26_AXI_wvalid(gp0_smc_M26_AXI_WVALID),
        .M27_AXI_araddr(gp0_smc_M27_AXI_ARADDR),
        .M27_AXI_arready(gp0_smc_M27_AXI_ARREADY),
        .M27_AXI_arvalid(gp0_smc_M27_AXI_ARVALID),
        .M27_AXI_awaddr(gp0_smc_M27_AXI_AWADDR),
        .M27_AXI_awready(gp0_smc_M27_AXI_AWREADY),
        .M27_AXI_awvalid(gp0_smc_M27_AXI_AWVALID),
        .M27_AXI_bready(gp0_smc_M27_AXI_BREADY),
        .M27_AXI_bresp(gp0_smc_M27_AXI_BRESP),
        .M27_AXI_bvalid(gp0_smc_M27_AXI_BVALID),
        .M27_AXI_rdata(gp0_smc_M27_AXI_RDATA),
        .M27_AXI_rready(gp0_smc_M27_AXI_RREADY),
        .M27_AXI_rresp(gp0_smc_M27_AXI_RRESP),
        .M27_AXI_rvalid(gp0_smc_M27_AXI_RVALID),
        .M27_AXI_wdata(gp0_smc_M27_AXI_WDATA),
        .M27_AXI_wready(gp0_smc_M27_AXI_WREADY),
        .M27_AXI_wstrb(gp0_smc_M27_AXI_WSTRB),
        .M27_AXI_wvalid(gp0_smc_M27_AXI_WVALID),
        .M28_AXI_araddr(gp0_smc_M28_AXI_ARADDR),
        .M28_AXI_arready(gp0_smc_M28_AXI_ARREADY),
        .M28_AXI_arvalid(gp0_smc_M28_AXI_ARVALID),
        .M28_AXI_awaddr(gp0_smc_M28_AXI_AWADDR),
        .M28_AXI_awready(gp0_smc_M28_AXI_AWREADY),
        .M28_AXI_awvalid(gp0_smc_M28_AXI_AWVALID),
        .M28_AXI_bready(gp0_smc_M28_AXI_BREADY),
        .M28_AXI_bresp(gp0_smc_M28_AXI_BRESP),
        .M28_AXI_bvalid(gp0_smc_M28_AXI_BVALID),
        .M28_AXI_rdata(gp0_smc_M28_AXI_RDATA),
        .M28_AXI_rready(gp0_smc_M28_AXI_RREADY),
        .M28_AXI_rresp(gp0_smc_M28_AXI_RRESP),
        .M28_AXI_rvalid(gp0_smc_M28_AXI_RVALID),
        .M28_AXI_wdata(gp0_smc_M28_AXI_WDATA),
        .M28_AXI_wready(gp0_smc_M28_AXI_WREADY),
        .M28_AXI_wstrb(gp0_smc_M28_AXI_WSTRB),
        .M28_AXI_wvalid(gp0_smc_M28_AXI_WVALID),
        .M29_AXI_araddr(gp0_smc_M29_AXI_ARADDR),
        .M29_AXI_arburst(gp0_smc_M29_AXI_ARBURST),
        .M29_AXI_arcache(gp0_smc_M29_AXI_ARCACHE),
        .M29_AXI_arid(gp0_smc_M29_AXI_ARID),
        .M29_AXI_arlen(gp0_smc_M29_AXI_ARLEN),
        .M29_AXI_arlock(gp0_smc_M29_AXI_ARLOCK),
        .M29_AXI_arprot(gp0_smc_M29_AXI_ARPROT),
        .M29_AXI_arqos(gp0_smc_M29_AXI_ARQOS),
        .M29_AXI_arready(gp0_smc_M29_AXI_ARREADY),
        .M29_AXI_arsize(gp0_smc_M29_AXI_ARSIZE),
        .M29_AXI_aruser(gp0_smc_M29_AXI_ARUSER),
        .M29_AXI_arvalid(gp0_smc_M29_AXI_ARVALID),
        .M29_AXI_awaddr(gp0_smc_M29_AXI_AWADDR),
        .M29_AXI_awburst(gp0_smc_M29_AXI_AWBURST),
        .M29_AXI_awcache(gp0_smc_M29_AXI_AWCACHE),
        .M29_AXI_awid(gp0_smc_M29_AXI_AWID),
        .M29_AXI_awlen(gp0_smc_M29_AXI_AWLEN),
        .M29_AXI_awlock(gp0_smc_M29_AXI_AWLOCK),
        .M29_AXI_awprot(gp0_smc_M29_AXI_AWPROT),
        .M29_AXI_awqos(gp0_smc_M29_AXI_AWQOS),
        .M29_AXI_awready(gp0_smc_M29_AXI_AWREADY),
        .M29_AXI_awsize(gp0_smc_M29_AXI_AWSIZE),
        .M29_AXI_awuser(gp0_smc_M29_AXI_AWUSER),
        .M29_AXI_awvalid(gp0_smc_M29_AXI_AWVALID),
        .M29_AXI_bid(gp0_smc_M29_AXI_BID),
        .M29_AXI_bready(gp0_smc_M29_AXI_BREADY),
        .M29_AXI_bresp(gp0_smc_M29_AXI_BRESP),
        .M29_AXI_bvalid(gp0_smc_M29_AXI_BVALID),
        .M29_AXI_rdata(gp0_smc_M29_AXI_RDATA),
        .M29_AXI_rid(gp0_smc_M29_AXI_RID),
        .M29_AXI_rlast(gp0_smc_M29_AXI_RLAST),
        .M29_AXI_rready(gp0_smc_M29_AXI_RREADY),
        .M29_AXI_rresp(gp0_smc_M29_AXI_RRESP),
        .M29_AXI_ruser(gp0_smc_M29_AXI_RUSER),
        .M29_AXI_rvalid(gp0_smc_M29_AXI_RVALID),
        .M29_AXI_wdata(gp0_smc_M29_AXI_WDATA),
        .M29_AXI_wlast(gp0_smc_M29_AXI_WLAST),
        .M29_AXI_wready(gp0_smc_M29_AXI_WREADY),
        .M29_AXI_wstrb(gp0_smc_M29_AXI_WSTRB),
        .M29_AXI_wuser(gp0_smc_M29_AXI_WUSER),
        .M29_AXI_wvalid(gp0_smc_M29_AXI_WVALID),
        .M30_AXI_araddr(gp0_smc_M30_AXI_ARADDR),
        .M30_AXI_arprot(gp0_smc_M30_AXI_ARPROT),
        .M30_AXI_arready(gp0_smc_M30_AXI_ARREADY),
        .M30_AXI_arvalid(gp0_smc_M30_AXI_ARVALID),
        .M30_AXI_awaddr(gp0_smc_M30_AXI_AWADDR),
        .M30_AXI_awprot(gp0_smc_M30_AXI_AWPROT),
        .M30_AXI_awready(gp0_smc_M30_AXI_AWREADY),
        .M30_AXI_awvalid(gp0_smc_M30_AXI_AWVALID),
        .M30_AXI_bready(gp0_smc_M30_AXI_BREADY),
        .M30_AXI_bresp(gp0_smc_M30_AXI_BRESP),
        .M30_AXI_bvalid(gp0_smc_M30_AXI_BVALID),
        .M30_AXI_rdata(gp0_smc_M30_AXI_RDATA),
        .M30_AXI_rready(gp0_smc_M30_AXI_RREADY),
        .M30_AXI_rresp(gp0_smc_M30_AXI_RRESP),
        .M30_AXI_rvalid(gp0_smc_M30_AXI_RVALID),
        .M30_AXI_wdata(gp0_smc_M30_AXI_WDATA),
        .M30_AXI_wready(gp0_smc_M30_AXI_WREADY),
        .M30_AXI_wstrb(gp0_smc_M30_AXI_WSTRB),
        .M30_AXI_wvalid(gp0_smc_M30_AXI_WVALID),
        .S00_AXI_araddr(vision_gp0_slice_M_AXI_ARADDR),
        .S00_AXI_arburst(vision_gp0_slice_M_AXI_ARBURST),
        .S00_AXI_arcache(vision_gp0_slice_M_AXI_ARCACHE),
        .S00_AXI_arid(vision_gp0_slice_M_AXI_ARID),
        .S00_AXI_arlen(vision_gp0_slice_M_AXI_ARLEN),
        .S00_AXI_arlock(vision_gp0_slice_M_AXI_ARLOCK),
        .S00_AXI_arprot(vision_gp0_slice_M_AXI_ARPROT),
        .S00_AXI_arqos(vision_gp0_slice_M_AXI_ARQOS),
        .S00_AXI_arready(vision_gp0_slice_M_AXI_ARREADY),
        .S00_AXI_arsize(vision_gp0_slice_M_AXI_ARSIZE),
        .S00_AXI_arvalid(vision_gp0_slice_M_AXI_ARVALID),
        .S00_AXI_awaddr(vision_gp0_slice_M_AXI_AWADDR),
        .S00_AXI_awburst(vision_gp0_slice_M_AXI_AWBURST),
        .S00_AXI_awcache(vision_gp0_slice_M_AXI_AWCACHE),
        .S00_AXI_awid(vision_gp0_slice_M_AXI_AWID),
        .S00_AXI_awlen(vision_gp0_slice_M_AXI_AWLEN),
        .S00_AXI_awlock(vision_gp0_slice_M_AXI_AWLOCK),
        .S00_AXI_awprot(vision_gp0_slice_M_AXI_AWPROT),
        .S00_AXI_awqos(vision_gp0_slice_M_AXI_AWQOS),
        .S00_AXI_awready(vision_gp0_slice_M_AXI_AWREADY),
        .S00_AXI_awsize(vision_gp0_slice_M_AXI_AWSIZE),
        .S00_AXI_awvalid(vision_gp0_slice_M_AXI_AWVALID),
        .S00_AXI_bid(vision_gp0_slice_M_AXI_BID),
        .S00_AXI_bready(vision_gp0_slice_M_AXI_BREADY),
        .S00_AXI_bresp(vision_gp0_slice_M_AXI_BRESP),
        .S00_AXI_bvalid(vision_gp0_slice_M_AXI_BVALID),
        .S00_AXI_rdata(vision_gp0_slice_M_AXI_RDATA),
        .S00_AXI_rid(vision_gp0_slice_M_AXI_RID),
        .S00_AXI_rlast(vision_gp0_slice_M_AXI_RLAST),
        .S00_AXI_rready(vision_gp0_slice_M_AXI_RREADY),
        .S00_AXI_rresp(vision_gp0_slice_M_AXI_RRESP),
        .S00_AXI_rvalid(vision_gp0_slice_M_AXI_RVALID),
        .S00_AXI_wdata(vision_gp0_slice_M_AXI_WDATA),
        .S00_AXI_wid(vision_gp0_slice_M_AXI_WID),
        .S00_AXI_wlast(vision_gp0_slice_M_AXI_WLAST),
        .S00_AXI_wready(vision_gp0_slice_M_AXI_WREADY),
        .S00_AXI_wstrb(vision_gp0_slice_M_AXI_WSTRB),
        .S00_AXI_wvalid(vision_gp0_slice_M_AXI_WVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_hp0_smc_0 hp0_smc
       (.M00_AXI_araddr(hp0_smc_M00_AXI_ARADDR),
        .M00_AXI_arburst(hp0_smc_M00_AXI_ARBURST),
        .M00_AXI_arcache(hp0_smc_M00_AXI_ARCACHE),
        .M00_AXI_arlen(hp0_smc_M00_AXI_ARLEN),
        .M00_AXI_arlock(hp0_smc_M00_AXI_ARLOCK),
        .M00_AXI_arprot(hp0_smc_M00_AXI_ARPROT),
        .M00_AXI_arqos(hp0_smc_M00_AXI_ARQOS),
        .M00_AXI_arready(hp0_smc_M00_AXI_ARREADY),
        .M00_AXI_arsize(hp0_smc_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(hp0_smc_M00_AXI_ARVALID),
        .M00_AXI_rdata(hp0_smc_M00_AXI_RDATA),
        .M00_AXI_rlast(hp0_smc_M00_AXI_RLAST),
        .M00_AXI_rready(hp0_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(hp0_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(hp0_smc_M00_AXI_RVALID),
        .S00_AXI_araddr(axi_dma_M_AXI_MM2S_ARADDR),
        .S00_AXI_arburst(axi_dma_M_AXI_MM2S_ARBURST),
        .S00_AXI_arcache(axi_dma_M_AXI_MM2S_ARCACHE),
        .S00_AXI_arlen(axi_dma_M_AXI_MM2S_ARLEN),
        .S00_AXI_arlock(1'b0),
        .S00_AXI_arprot(axi_dma_M_AXI_MM2S_ARPROT),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(axi_dma_M_AXI_MM2S_ARREADY),
        .S00_AXI_arsize(axi_dma_M_AXI_MM2S_ARSIZE),
        .S00_AXI_arvalid(axi_dma_M_AXI_MM2S_ARVALID),
        .S00_AXI_rdata(axi_dma_M_AXI_MM2S_RDATA),
        .S00_AXI_rlast(axi_dma_M_AXI_MM2S_RLAST),
        .S00_AXI_rready(axi_dma_M_AXI_MM2S_RREADY),
        .S00_AXI_rresp(axi_dma_M_AXI_MM2S_RRESP),
        .S00_AXI_rvalid(axi_dma_M_AXI_MM2S_RVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_hp2_smc_0 hp2_smc
       (.M00_AXI_awaddr(hp2_smc_M00_AXI_AWADDR),
        .M00_AXI_awburst(hp2_smc_M00_AXI_AWBURST),
        .M00_AXI_awcache(hp2_smc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(hp2_smc_M00_AXI_AWLEN),
        .M00_AXI_awlock(hp2_smc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(hp2_smc_M00_AXI_AWPROT),
        .M00_AXI_awqos(hp2_smc_M00_AXI_AWQOS),
        .M00_AXI_awready(hp2_smc_M00_AXI_AWREADY),
        .M00_AXI_awsize(hp2_smc_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(hp2_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(hp2_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(hp2_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(hp2_smc_M00_AXI_BVALID),
        .M00_AXI_wdata(hp2_smc_M00_AXI_WDATA),
        .M00_AXI_wlast(hp2_smc_M00_AXI_WLAST),
        .M00_AXI_wready(hp2_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(hp2_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(hp2_smc_M00_AXI_WVALID),
        .S00_AXI_awaddr(return_dma_M_AXI_S2MM_AWADDR),
        .S00_AXI_awburst(return_dma_M_AXI_S2MM_AWBURST),
        .S00_AXI_awcache(return_dma_M_AXI_S2MM_AWCACHE),
        .S00_AXI_awlen(return_dma_M_AXI_S2MM_AWLEN),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot(return_dma_M_AXI_S2MM_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(return_dma_M_AXI_S2MM_AWREADY),
        .S00_AXI_awsize(return_dma_M_AXI_S2MM_AWSIZE),
        .S00_AXI_awvalid(return_dma_M_AXI_S2MM_AWVALID),
        .S00_AXI_bready(return_dma_M_AXI_S2MM_BREADY),
        .S00_AXI_bresp(return_dma_M_AXI_S2MM_BRESP),
        .S00_AXI_bvalid(return_dma_M_AXI_S2MM_BVALID),
        .S00_AXI_wdata(return_dma_M_AXI_S2MM_WDATA),
        .S00_AXI_wlast(return_dma_M_AXI_S2MM_WLAST),
        .S00_AXI_wready(return_dma_M_AXI_S2MM_WREADY),
        .S00_AXI_wstrb(return_dma_M_AXI_S2MM_WSTRB),
        .S00_AXI_wvalid(return_dma_M_AXI_S2MM_WVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_input_osd_0_0 input_osd_0
       (.in_de(core_vid_de),
        .in_hs(core_vid_hsync),
        .in_rgb(core_vid_data),
        .in_vs(core_vid_vsync),
        .out_de(input_osd_0_out_de),
        .out_hs(input_osd_0_out_hs),
        .out_rgb(input_osd_0_out_rgb),
        .out_vs(input_osd_0_out_vs),
        .pclk(pixel_clock_clk_out1),
        .presetn(rst_pixel_peripheral_aresetn),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(vision_control_smc_M05_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arprot(vision_control_smc_M05_AXI_ARPROT),
        .s_axi_arready(vision_control_smc_M05_AXI_ARREADY),
        .s_axi_arvalid(vision_control_smc_M05_AXI_ARVALID),
        .s_axi_awaddr(vision_control_smc_M05_AXI_AWADDR),
        .s_axi_awprot(vision_control_smc_M05_AXI_AWPROT),
        .s_axi_awready(vision_control_smc_M05_AXI_AWREADY),
        .s_axi_awvalid(vision_control_smc_M05_AXI_AWVALID),
        .s_axi_bready(vision_control_smc_M05_AXI_BREADY),
        .s_axi_bresp(vision_control_smc_M05_AXI_BRESP),
        .s_axi_bvalid(vision_control_smc_M05_AXI_BVALID),
        .s_axi_rdata(vision_control_smc_M05_AXI_RDATA),
        .s_axi_rready(vision_control_smc_M05_AXI_RREADY),
        .s_axi_rresp(vision_control_smc_M05_AXI_RRESP),
        .s_axi_rvalid(vision_control_smc_M05_AXI_RVALID),
        .s_axi_wdata(vision_control_smc_M05_AXI_WDATA),
        .s_axi_wready(vision_control_smc_M05_AXI_WREADY),
        .s_axi_wstrb(vision_control_smc_M05_AXI_WSTRB),
        .s_axi_wvalid(vision_control_smc_M05_AXI_WVALID));
  c6v_irq_concat_0 irq_concat
       (.In0(axi_dma_mm2s_introut),
        .In1(return_dma_s2mm_introut),
        .In2(frame_dma_s2mm_introut),
        .In3(sdata_o),
        .In4(moments_dma_s2mm_introut),
        .dout(irq_concat_dout));
  c6v_moments_dma_0 moments_dma
       (.axi_resetn(rst_fclk0_peripheral_aresetn),
        .m_axi_s2mm_aclk(ps7_0_FCLK_CLK0),
        .m_axi_s2mm_awaddr(moments_dma_M_AXI_S2MM_AWADDR),
        .m_axi_s2mm_awburst(moments_dma_M_AXI_S2MM_AWBURST),
        .m_axi_s2mm_awcache(moments_dma_M_AXI_S2MM_AWCACHE),
        .m_axi_s2mm_awlen(moments_dma_M_AXI_S2MM_AWLEN),
        .m_axi_s2mm_awprot(moments_dma_M_AXI_S2MM_AWPROT),
        .m_axi_s2mm_awready(moments_dma_M_AXI_S2MM_AWREADY),
        .m_axi_s2mm_awsize(moments_dma_M_AXI_S2MM_AWSIZE),
        .m_axi_s2mm_awvalid(moments_dma_M_AXI_S2MM_AWVALID),
        .m_axi_s2mm_bready(moments_dma_M_AXI_S2MM_BREADY),
        .m_axi_s2mm_bresp(moments_dma_M_AXI_S2MM_BRESP),
        .m_axi_s2mm_bvalid(moments_dma_M_AXI_S2MM_BVALID),
        .m_axi_s2mm_wdata(moments_dma_M_AXI_S2MM_WDATA),
        .m_axi_s2mm_wlast(moments_dma_M_AXI_S2MM_WLAST),
        .m_axi_s2mm_wready(moments_dma_M_AXI_S2MM_WREADY),
        .m_axi_s2mm_wstrb(moments_dma_M_AXI_S2MM_WSTRB),
        .m_axi_s2mm_wvalid(moments_dma_M_AXI_S2MM_WVALID),
        .m_axi_sg_aclk(ps7_0_FCLK_CLK0),
        .m_axi_sg_araddr(moments_dma_M_AXI_SG_ARADDR),
        .m_axi_sg_arburst(moments_dma_M_AXI_SG_ARBURST),
        .m_axi_sg_arcache(moments_dma_M_AXI_SG_ARCACHE),
        .m_axi_sg_arlen(moments_dma_M_AXI_SG_ARLEN),
        .m_axi_sg_arprot(moments_dma_M_AXI_SG_ARPROT),
        .m_axi_sg_arready(moments_dma_M_AXI_SG_ARREADY),
        .m_axi_sg_arsize(moments_dma_M_AXI_SG_ARSIZE),
        .m_axi_sg_arvalid(moments_dma_M_AXI_SG_ARVALID),
        .m_axi_sg_awaddr(moments_dma_M_AXI_SG_AWADDR),
        .m_axi_sg_awburst(moments_dma_M_AXI_SG_AWBURST),
        .m_axi_sg_awcache(moments_dma_M_AXI_SG_AWCACHE),
        .m_axi_sg_awlen(moments_dma_M_AXI_SG_AWLEN),
        .m_axi_sg_awprot(moments_dma_M_AXI_SG_AWPROT),
        .m_axi_sg_awready(moments_dma_M_AXI_SG_AWREADY),
        .m_axi_sg_awsize(moments_dma_M_AXI_SG_AWSIZE),
        .m_axi_sg_awvalid(moments_dma_M_AXI_SG_AWVALID),
        .m_axi_sg_bready(moments_dma_M_AXI_SG_BREADY),
        .m_axi_sg_bresp(moments_dma_M_AXI_SG_BRESP),
        .m_axi_sg_bvalid(moments_dma_M_AXI_SG_BVALID),
        .m_axi_sg_rdata(moments_dma_M_AXI_SG_RDATA),
        .m_axi_sg_rlast(moments_dma_M_AXI_SG_RLAST),
        .m_axi_sg_rready(moments_dma_M_AXI_SG_RREADY),
        .m_axi_sg_rresp(moments_dma_M_AXI_SG_RRESP),
        .m_axi_sg_rvalid(moments_dma_M_AXI_SG_RVALID),
        .m_axi_sg_wdata(moments_dma_M_AXI_SG_WDATA),
        .m_axi_sg_wlast(moments_dma_M_AXI_SG_WLAST),
        .m_axi_sg_wready(moments_dma_M_AXI_SG_WREADY),
        .m_axi_sg_wstrb(moments_dma_M_AXI_SG_WSTRB),
        .m_axi_sg_wvalid(moments_dma_M_AXI_SG_WVALID),
        .s2mm_introut(moments_dma_s2mm_introut),
        .s_axi_lite_aclk(ps7_0_FCLK_CLK0),
        .s_axi_lite_araddr(vision_control_smc_M03_AXI_ARADDR),
        .s_axi_lite_arready(vision_control_smc_M03_AXI_ARREADY),
        .s_axi_lite_arvalid(vision_control_smc_M03_AXI_ARVALID),
        .s_axi_lite_awaddr(vision_control_smc_M03_AXI_AWADDR),
        .s_axi_lite_awready(vision_control_smc_M03_AXI_AWREADY),
        .s_axi_lite_awvalid(vision_control_smc_M03_AXI_AWVALID),
        .s_axi_lite_bready(vision_control_smc_M03_AXI_BREADY),
        .s_axi_lite_bresp(vision_control_smc_M03_AXI_BRESP),
        .s_axi_lite_bvalid(vision_control_smc_M03_AXI_BVALID),
        .s_axi_lite_rdata(vision_control_smc_M03_AXI_RDATA),
        .s_axi_lite_rready(vision_control_smc_M03_AXI_RREADY),
        .s_axi_lite_rresp(vision_control_smc_M03_AXI_RRESP),
        .s_axi_lite_rvalid(vision_control_smc_M03_AXI_RVALID),
        .s_axi_lite_wdata(vision_control_smc_M03_AXI_WDATA),
        .s_axi_lite_wready(vision_control_smc_M03_AXI_WREADY),
        .s_axi_lite_wvalid(vision_control_smc_M03_AXI_WVALID),
        .s_axis_s2mm_tdata(packet_stream_width_M_AXIS_TDATA),
        .s_axis_s2mm_tkeep(packet_stream_width_M_AXIS_TKEEP),
        .s_axis_s2mm_tlast(packet_stream_width_M_AXIS_TLAST),
        .s_axis_s2mm_tready(packet_stream_width_M_AXIS_TREADY),
        .s_axis_s2mm_tvalid(packet_stream_width_M_AXIS_TVALID));
  c6v_moments_reset_0 moments_reset
       (.gpio_io_o(moments_reset_gpio_io_o),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(vision_control_smc_M04_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(vision_control_smc_M04_AXI_ARREADY),
        .s_axi_arvalid(vision_control_smc_M04_AXI_ARVALID),
        .s_axi_awaddr(vision_control_smc_M04_AXI_AWADDR),
        .s_axi_awready(vision_control_smc_M04_AXI_AWREADY),
        .s_axi_awvalid(vision_control_smc_M04_AXI_AWVALID),
        .s_axi_bready(vision_control_smc_M04_AXI_BREADY),
        .s_axi_bresp(vision_control_smc_M04_AXI_BRESP),
        .s_axi_bvalid(vision_control_smc_M04_AXI_BVALID),
        .s_axi_rdata(vision_control_smc_M04_AXI_RDATA),
        .s_axi_rready(vision_control_smc_M04_AXI_RREADY),
        .s_axi_rresp(vision_control_smc_M04_AXI_RRESP),
        .s_axi_rvalid(vision_control_smc_M04_AXI_RVALID),
        .s_axi_wdata(vision_control_smc_M04_AXI_WDATA),
        .s_axi_wready(vision_control_smc_M04_AXI_WREADY),
        .s_axi_wstrb(vision_control_smc_M04_AXI_WSTRB),
        .s_axi_wvalid(vision_control_smc_M04_AXI_WVALID));
  c6v_overlap_release_constant_0 overlap_release_constant
       (.dout(overlap_release_constant_dout));
  c6v_packet_status_gpio_0 packet_status_gpio
       (.gpio2_io_i(core_accepted_packet_count),
        .gpio_io_i(core_upload_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M03_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M03_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M03_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M03_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M03_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M03_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M03_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M03_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M03_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M03_AXI_RDATA),
        .s_axi_rready(gp0_smc_M03_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M03_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M03_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M03_AXI_WDATA),
        .s_axi_wready(gp0_smc_M03_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M03_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M03_AXI_WVALID));
  c6v_packet_stream_width_0 packet_stream_width
       (.aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .m_axis_tdata(packet_stream_width_M_AXIS_TDATA),
        .m_axis_tkeep(packet_stream_width_M_AXIS_TKEEP),
        .m_axis_tlast(packet_stream_width_M_AXIS_TLAST),
        .m_axis_tready(packet_stream_width_M_AXIS_TREADY),
        .m_axis_tvalid(packet_stream_width_M_AXIS_TVALID),
        .s_axis_tdata(dual_mask_capture_M_PACKET_TDATA),
        .s_axis_tkeep(dual_mask_capture_M_PACKET_TKEEP),
        .s_axis_tlast(dual_mask_capture_M_PACKET_TLAST),
        .s_axis_tready(dual_mask_capture_M_PACKET_TREADY),
        .s_axis_tvalid(dual_mask_capture_M_PACKET_TVALID));
  c6v_palette_generation_status_gpio_0 palette_generation_status_gpio
       (.gpio2_io_i(core_palette_error_flags),
        .gpio_io_i(core_palette_generation),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M16_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M16_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M16_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M16_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M16_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M16_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M16_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M16_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M16_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M16_AXI_RDATA),
        .s_axi_rready(gp0_smc_M16_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M16_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M16_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M16_AXI_WDATA),
        .s_axi_wready(gp0_smc_M16_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M16_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M16_AXI_WVALID));
  c6v_palette_packet_status_gpio_0 palette_packet_status_gpio
       (.gpio2_io_i(core_palette_rejected_packet_count),
        .gpio_io_i(core_palette_accepted_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M15_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M15_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M15_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M15_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M15_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M15_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M15_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M15_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M15_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M15_AXI_RDATA),
        .s_axi_rready(gp0_smc_M15_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M15_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M15_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M15_AXI_WDATA),
        .s_axi_wready(gp0_smc_M15_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M15_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M15_AXI_WVALID));
  c6v_palette_state_status_gpio_0 palette_state_status_gpio
       (.gpio_io_i(core_palette_status),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M17_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M17_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M17_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M17_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M17_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M17_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M17_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M17_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M17_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M17_AXI_RDATA),
        .s_axi_rready(gp0_smc_M17_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M17_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M17_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M17_AXI_WDATA),
        .s_axi_wready(gp0_smc_M17_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M17_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M17_AXI_WVALID));
  c6v_pixel_clock_0 pixel_clock
       (.clk_in1(ps7_0_FCLK_CLK0),
        .clk_out1(pixel_clock_clk_out1),
        .locked(pixel_clock_locked),
        .reset(rst_fclk0_peripheral_reset));
  c6v_present_completion_gpio_0 present_completion_gpio
       (.gpio2_io_i(core_present_completed_count),
        .gpio_io_i(core_present_completed_seq),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M12_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M12_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M12_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M12_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M12_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M12_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M12_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M12_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M12_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M12_AXI_RDATA),
        .s_axi_rready(gp0_smc_M12_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M12_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M12_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M12_AXI_WDATA),
        .s_axi_wready(gp0_smc_M12_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M12_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M12_AXI_WVALID));
  c6v_ps7_0_0 ps7_0
       (.DDR_Addr(DDR_addr),
        .DDR_BankAddr(DDR_ba),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm),
        .DDR_DQ(DDR_dq),
        .DDR_DQS(DDR_dqs_p),
        .DDR_DQS_n(DDR_dqs_n),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .FCLK_CLK0(ps7_0_FCLK_CLK0),
        .FCLK_CLK1(vid_xclk),
        .FCLK_RESET0_N(ps7_0_FCLK_RESET0_N),
        .I2C1_SCL_I(IIC_1_scl_i),
        .I2C1_SCL_O(IIC_1_scl_o),
        .I2C1_SCL_T(IIC_1_scl_t),
        .I2C1_SDA_I(IIC_1_sda_i),
        .I2C1_SDA_O(IIC_1_sda_o),
        .I2C1_SDA_T(IIC_1_sda_t),
        .IRQ_F2P(irq_concat_dout),
        .MIO(FIXED_IO_mio),
        .M_AXI_GP0_ACLK(ps7_0_FCLK_CLK0),
        .M_AXI_GP0_ARADDR(ps7_0_M_AXI_GP0_ARADDR),
        .M_AXI_GP0_ARBURST(ps7_0_M_AXI_GP0_ARBURST),
        .M_AXI_GP0_ARCACHE(ps7_0_M_AXI_GP0_ARCACHE),
        .M_AXI_GP0_ARID(ps7_0_M_AXI_GP0_ARID),
        .M_AXI_GP0_ARLEN(ps7_0_M_AXI_GP0_ARLEN),
        .M_AXI_GP0_ARLOCK(ps7_0_M_AXI_GP0_ARLOCK),
        .M_AXI_GP0_ARPROT(ps7_0_M_AXI_GP0_ARPROT),
        .M_AXI_GP0_ARQOS(ps7_0_M_AXI_GP0_ARQOS),
        .M_AXI_GP0_ARREADY(ps7_0_M_AXI_GP0_ARREADY),
        .M_AXI_GP0_ARSIZE(ps7_0_M_AXI_GP0_ARSIZE),
        .M_AXI_GP0_ARVALID(ps7_0_M_AXI_GP0_ARVALID),
        .M_AXI_GP0_AWADDR(ps7_0_M_AXI_GP0_AWADDR),
        .M_AXI_GP0_AWBURST(ps7_0_M_AXI_GP0_AWBURST),
        .M_AXI_GP0_AWCACHE(ps7_0_M_AXI_GP0_AWCACHE),
        .M_AXI_GP0_AWID(ps7_0_M_AXI_GP0_AWID),
        .M_AXI_GP0_AWLEN(ps7_0_M_AXI_GP0_AWLEN),
        .M_AXI_GP0_AWLOCK(ps7_0_M_AXI_GP0_AWLOCK),
        .M_AXI_GP0_AWPROT(ps7_0_M_AXI_GP0_AWPROT),
        .M_AXI_GP0_AWQOS(ps7_0_M_AXI_GP0_AWQOS),
        .M_AXI_GP0_AWREADY(ps7_0_M_AXI_GP0_AWREADY),
        .M_AXI_GP0_AWSIZE(ps7_0_M_AXI_GP0_AWSIZE),
        .M_AXI_GP0_AWVALID(ps7_0_M_AXI_GP0_AWVALID),
        .M_AXI_GP0_BID(ps7_0_M_AXI_GP0_BID),
        .M_AXI_GP0_BREADY(ps7_0_M_AXI_GP0_BREADY),
        .M_AXI_GP0_BRESP(ps7_0_M_AXI_GP0_BRESP),
        .M_AXI_GP0_BVALID(ps7_0_M_AXI_GP0_BVALID),
        .M_AXI_GP0_RDATA(ps7_0_M_AXI_GP0_RDATA),
        .M_AXI_GP0_RID(ps7_0_M_AXI_GP0_RID),
        .M_AXI_GP0_RLAST(ps7_0_M_AXI_GP0_RLAST),
        .M_AXI_GP0_RREADY(ps7_0_M_AXI_GP0_RREADY),
        .M_AXI_GP0_RRESP(ps7_0_M_AXI_GP0_RRESP),
        .M_AXI_GP0_RVALID(ps7_0_M_AXI_GP0_RVALID),
        .M_AXI_GP0_WDATA(ps7_0_M_AXI_GP0_WDATA),
        .M_AXI_GP0_WID(ps7_0_M_AXI_GP0_WID),
        .M_AXI_GP0_WLAST(ps7_0_M_AXI_GP0_WLAST),
        .M_AXI_GP0_WREADY(ps7_0_M_AXI_GP0_WREADY),
        .M_AXI_GP0_WSTRB(ps7_0_M_AXI_GP0_WSTRB),
        .M_AXI_GP0_WVALID(ps7_0_M_AXI_GP0_WVALID),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .S_AXI_HP0_ACLK(ps7_0_FCLK_CLK0),
        .S_AXI_HP0_ARADDR(hp0_smc_M00_AXI_ARADDR),
        .S_AXI_HP0_ARBURST(hp0_smc_M00_AXI_ARBURST),
        .S_AXI_HP0_ARCACHE(hp0_smc_M00_AXI_ARCACHE),
        .S_AXI_HP0_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_ARLEN(hp0_smc_M00_AXI_ARLEN),
        .S_AXI_HP0_ARLOCK(hp0_smc_M00_AXI_ARLOCK),
        .S_AXI_HP0_ARPROT(hp0_smc_M00_AXI_ARPROT),
        .S_AXI_HP0_ARQOS(hp0_smc_M00_AXI_ARQOS),
        .S_AXI_HP0_ARREADY(hp0_smc_M00_AXI_ARREADY),
        .S_AXI_HP0_ARSIZE(hp0_smc_M00_AXI_ARSIZE),
        .S_AXI_HP0_ARVALID(hp0_smc_M00_AXI_ARVALID),
        .S_AXI_HP0_AWADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_AWBURST({1'b0,1'b1}),
        .S_AXI_HP0_AWCACHE({1'b0,1'b0,1'b1,1'b1}),
        .S_AXI_HP0_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_AWLEN({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_AWLOCK({1'b0,1'b0}),
        .S_AXI_HP0_AWPROT({1'b0,1'b0,1'b0}),
        .S_AXI_HP0_AWQOS({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_AWSIZE({1'b0,1'b1,1'b1}),
        .S_AXI_HP0_AWVALID(1'b0),
        .S_AXI_HP0_BREADY(1'b0),
        .S_AXI_HP0_RDATA(hp0_smc_M00_AXI_RDATA),
        .S_AXI_HP0_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP0_RLAST(hp0_smc_M00_AXI_RLAST),
        .S_AXI_HP0_RREADY(hp0_smc_M00_AXI_RREADY),
        .S_AXI_HP0_RRESP(hp0_smc_M00_AXI_RRESP),
        .S_AXI_HP0_RVALID(hp0_smc_M00_AXI_RVALID),
        .S_AXI_HP0_WDATA({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_WID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP0_WLAST(1'b0),
        .S_AXI_HP0_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP0_WSTRB({1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1}),
        .S_AXI_HP0_WVALID(1'b0),
        .S_AXI_HP1_ACLK(ps7_0_FCLK_CLK0),
        .S_AXI_HP1_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_ARBURST({1'b0,1'b1}),
        .S_AXI_HP1_ARCACHE({1'b0,1'b0,1'b1,1'b1}),
        .S_AXI_HP1_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_ARLEN({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_ARLOCK({1'b0,1'b0}),
        .S_AXI_HP1_ARPROT({1'b0,1'b0,1'b0}),
        .S_AXI_HP1_ARQOS({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_ARSIZE({1'b0,1'b1,1'b1}),
        .S_AXI_HP1_ARVALID(1'b0),
        .S_AXI_HP1_AWADDR(camera_hp1_smc_M00_AXI_AWADDR),
        .S_AXI_HP1_AWBURST(camera_hp1_smc_M00_AXI_AWBURST),
        .S_AXI_HP1_AWCACHE(camera_hp1_smc_M00_AXI_AWCACHE),
        .S_AXI_HP1_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_AWLEN(camera_hp1_smc_M00_AXI_AWLEN),
        .S_AXI_HP1_AWLOCK(camera_hp1_smc_M00_AXI_AWLOCK),
        .S_AXI_HP1_AWPROT(camera_hp1_smc_M00_AXI_AWPROT),
        .S_AXI_HP1_AWQOS(camera_hp1_smc_M00_AXI_AWQOS),
        .S_AXI_HP1_AWREADY(camera_hp1_smc_M00_AXI_AWREADY),
        .S_AXI_HP1_AWSIZE(camera_hp1_smc_M00_AXI_AWSIZE),
        .S_AXI_HP1_AWVALID(camera_hp1_smc_M00_AXI_AWVALID),
        .S_AXI_HP1_BREADY(camera_hp1_smc_M00_AXI_BREADY),
        .S_AXI_HP1_BRESP(camera_hp1_smc_M00_AXI_BRESP),
        .S_AXI_HP1_BVALID(camera_hp1_smc_M00_AXI_BVALID),
        .S_AXI_HP1_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP1_RREADY(1'b0),
        .S_AXI_HP1_WDATA(camera_hp1_smc_M00_AXI_WDATA),
        .S_AXI_HP1_WID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP1_WLAST(camera_hp1_smc_M00_AXI_WLAST),
        .S_AXI_HP1_WREADY(camera_hp1_smc_M00_AXI_WREADY),
        .S_AXI_HP1_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP1_WSTRB(camera_hp1_smc_M00_AXI_WSTRB),
        .S_AXI_HP1_WVALID(camera_hp1_smc_M00_AXI_WVALID),
        .S_AXI_HP2_ACLK(ps7_0_FCLK_CLK0),
        .S_AXI_HP2_ARADDR({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_ARBURST({1'b0,1'b1}),
        .S_AXI_HP2_ARCACHE({1'b0,1'b0,1'b1,1'b1}),
        .S_AXI_HP2_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_ARLEN({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_ARLOCK({1'b0,1'b0}),
        .S_AXI_HP2_ARPROT({1'b0,1'b0,1'b0}),
        .S_AXI_HP2_ARQOS({1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_ARSIZE({1'b0,1'b1,1'b1}),
        .S_AXI_HP2_ARVALID(1'b0),
        .S_AXI_HP2_AWADDR(hp2_smc_M00_AXI_AWADDR),
        .S_AXI_HP2_AWBURST(hp2_smc_M00_AXI_AWBURST),
        .S_AXI_HP2_AWCACHE(hp2_smc_M00_AXI_AWCACHE),
        .S_AXI_HP2_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_AWLEN(hp2_smc_M00_AXI_AWLEN),
        .S_AXI_HP2_AWLOCK(hp2_smc_M00_AXI_AWLOCK),
        .S_AXI_HP2_AWPROT(hp2_smc_M00_AXI_AWPROT),
        .S_AXI_HP2_AWQOS(hp2_smc_M00_AXI_AWQOS),
        .S_AXI_HP2_AWREADY(hp2_smc_M00_AXI_AWREADY),
        .S_AXI_HP2_AWSIZE(hp2_smc_M00_AXI_AWSIZE),
        .S_AXI_HP2_AWVALID(hp2_smc_M00_AXI_AWVALID),
        .S_AXI_HP2_BREADY(hp2_smc_M00_AXI_BREADY),
        .S_AXI_HP2_BRESP(hp2_smc_M00_AXI_BRESP),
        .S_AXI_HP2_BVALID(hp2_smc_M00_AXI_BVALID),
        .S_AXI_HP2_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP2_RREADY(1'b0),
        .S_AXI_HP2_WDATA(hp2_smc_M00_AXI_WDATA),
        .S_AXI_HP2_WID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP2_WLAST(hp2_smc_M00_AXI_WLAST),
        .S_AXI_HP2_WREADY(hp2_smc_M00_AXI_WREADY),
        .S_AXI_HP2_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP2_WSTRB(hp2_smc_M00_AXI_WSTRB),
        .S_AXI_HP2_WVALID(hp2_smc_M00_AXI_WVALID),
        .S_AXI_HP3_ACLK(ps7_0_FCLK_CLK0),
        .S_AXI_HP3_ARADDR(skin_hp3_smc_M00_AXI_ARADDR),
        .S_AXI_HP3_ARBURST(skin_hp3_smc_M00_AXI_ARBURST),
        .S_AXI_HP3_ARCACHE(skin_hp3_smc_M00_AXI_ARCACHE),
        .S_AXI_HP3_ARID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP3_ARLEN(skin_hp3_smc_M00_AXI_ARLEN),
        .S_AXI_HP3_ARLOCK(skin_hp3_smc_M00_AXI_ARLOCK),
        .S_AXI_HP3_ARPROT(skin_hp3_smc_M00_AXI_ARPROT),
        .S_AXI_HP3_ARQOS(skin_hp3_smc_M00_AXI_ARQOS),
        .S_AXI_HP3_ARREADY(skin_hp3_smc_M00_AXI_ARREADY),
        .S_AXI_HP3_ARSIZE(skin_hp3_smc_M00_AXI_ARSIZE),
        .S_AXI_HP3_ARVALID(skin_hp3_smc_M00_AXI_ARVALID),
        .S_AXI_HP3_AWADDR(skin_hp3_smc_M00_AXI_AWADDR),
        .S_AXI_HP3_AWBURST(skin_hp3_smc_M00_AXI_AWBURST),
        .S_AXI_HP3_AWCACHE(skin_hp3_smc_M00_AXI_AWCACHE),
        .S_AXI_HP3_AWID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP3_AWLEN(skin_hp3_smc_M00_AXI_AWLEN),
        .S_AXI_HP3_AWLOCK(skin_hp3_smc_M00_AXI_AWLOCK),
        .S_AXI_HP3_AWPROT(skin_hp3_smc_M00_AXI_AWPROT),
        .S_AXI_HP3_AWQOS(skin_hp3_smc_M00_AXI_AWQOS),
        .S_AXI_HP3_AWREADY(skin_hp3_smc_M00_AXI_AWREADY),
        .S_AXI_HP3_AWSIZE(skin_hp3_smc_M00_AXI_AWSIZE),
        .S_AXI_HP3_AWVALID(skin_hp3_smc_M00_AXI_AWVALID),
        .S_AXI_HP3_BREADY(skin_hp3_smc_M00_AXI_BREADY),
        .S_AXI_HP3_BRESP(skin_hp3_smc_M00_AXI_BRESP),
        .S_AXI_HP3_BVALID(skin_hp3_smc_M00_AXI_BVALID),
        .S_AXI_HP3_RDATA(skin_hp3_smc_M00_AXI_RDATA),
        .S_AXI_HP3_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP3_RLAST(skin_hp3_smc_M00_AXI_RLAST),
        .S_AXI_HP3_RREADY(skin_hp3_smc_M00_AXI_RREADY),
        .S_AXI_HP3_RRESP(skin_hp3_smc_M00_AXI_RRESP),
        .S_AXI_HP3_RVALID(skin_hp3_smc_M00_AXI_RVALID),
        .S_AXI_HP3_WDATA(skin_hp3_smc_M00_AXI_WDATA),
        .S_AXI_HP3_WID({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .S_AXI_HP3_WLAST(skin_hp3_smc_M00_AXI_WLAST),
        .S_AXI_HP3_WREADY(skin_hp3_smc_M00_AXI_WREADY),
        .S_AXI_HP3_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP3_WSTRB(skin_hp3_smc_M00_AXI_WSTRB),
        .S_AXI_HP3_WVALID(skin_hp3_smc_M00_AXI_WVALID),
        .USB0_VBUS_PWRFAULT(1'b0));
  c6v_render_completion_gpio_0 render_completion_gpio
       (.gpio2_io_i(core_render_completed_count),
        .gpio_io_i(core_render_completed_seq),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M08_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M08_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M08_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M08_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M08_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M08_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M08_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M08_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M08_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M08_AXI_RDATA),
        .s_axi_rready(gp0_smc_M08_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M08_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M08_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M08_AXI_WDATA),
        .s_axi_wready(gp0_smc_M08_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M08_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M08_AXI_WVALID));
  c6v_render_cycles_gpio_0 render_cycles_gpio
       (.gpio2_io_i(core_render_maximum_cycles),
        .gpio_io_i(core_render_cycles),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M10_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M10_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M10_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M10_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M10_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M10_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M10_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M10_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M10_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M10_AXI_RDATA),
        .s_axi_rready(gp0_smc_M10_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M10_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M10_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M10_AXI_WDATA),
        .s_axi_wready(gp0_smc_M10_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M10_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M10_AXI_WVALID));
  c6v_render_status_gpio_0 render_status_gpio
       (.gpio_io_i(core_render_status),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M11_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M11_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M11_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M11_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M11_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M11_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M11_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M11_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M11_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M11_AXI_RDATA),
        .s_axi_rready(gp0_smc_M11_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M11_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M11_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M11_AXI_WDATA),
        .s_axi_wready(gp0_smc_M11_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M11_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M11_AXI_WVALID));
  c6v_render_trace_gpio_0 render_trace_gpio
       (.gpio2_io_i(core_render_write_count),
        .gpio_io_i(core_render_trace_crc32),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M09_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M09_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M09_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M09_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M09_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M09_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M09_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M09_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M09_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M09_AXI_RDATA),
        .s_axi_rready(gp0_smc_M09_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M09_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M09_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M09_AXI_WDATA),
        .s_axi_wready(gp0_smc_M09_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M09_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M09_AXI_WVALID));
  c6v_return_control_gpio_0 return_control_gpio
       (.gpio2_io_o(return_control_gpio_gpio2_io_o),
        .gpio_io_o(return_control_gpio_gpio_io_o),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M25_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M25_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M25_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M25_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M25_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M25_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M25_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M25_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M25_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M25_AXI_RDATA),
        .s_axi_rready(gp0_smc_M25_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M25_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M25_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M25_AXI_WDATA),
        .s_axi_wready(gp0_smc_M25_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M25_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M25_AXI_WVALID));
  c6v_return_dma_0 return_dma
       (.axi_resetn(rst_fclk0_peripheral_aresetn),
        .m_axi_s2mm_aclk(ps7_0_FCLK_CLK0),
        .m_axi_s2mm_awaddr(return_dma_M_AXI_S2MM_AWADDR),
        .m_axi_s2mm_awburst(return_dma_M_AXI_S2MM_AWBURST),
        .m_axi_s2mm_awcache(return_dma_M_AXI_S2MM_AWCACHE),
        .m_axi_s2mm_awlen(return_dma_M_AXI_S2MM_AWLEN),
        .m_axi_s2mm_awprot(return_dma_M_AXI_S2MM_AWPROT),
        .m_axi_s2mm_awready(return_dma_M_AXI_S2MM_AWREADY),
        .m_axi_s2mm_awsize(return_dma_M_AXI_S2MM_AWSIZE),
        .m_axi_s2mm_awvalid(return_dma_M_AXI_S2MM_AWVALID),
        .m_axi_s2mm_bready(return_dma_M_AXI_S2MM_BREADY),
        .m_axi_s2mm_bresp(return_dma_M_AXI_S2MM_BRESP),
        .m_axi_s2mm_bvalid(return_dma_M_AXI_S2MM_BVALID),
        .m_axi_s2mm_wdata(return_dma_M_AXI_S2MM_WDATA),
        .m_axi_s2mm_wlast(return_dma_M_AXI_S2MM_WLAST),
        .m_axi_s2mm_wready(return_dma_M_AXI_S2MM_WREADY),
        .m_axi_s2mm_wstrb(return_dma_M_AXI_S2MM_WSTRB),
        .m_axi_s2mm_wvalid(return_dma_M_AXI_S2MM_WVALID),
        .s2mm_introut(return_dma_s2mm_introut),
        .s_axi_lite_aclk(ps7_0_FCLK_CLK0),
        .s_axi_lite_araddr(gp0_smc_M24_AXI_ARADDR),
        .s_axi_lite_arready(gp0_smc_M24_AXI_ARREADY),
        .s_axi_lite_arvalid(gp0_smc_M24_AXI_ARVALID),
        .s_axi_lite_awaddr(gp0_smc_M24_AXI_AWADDR),
        .s_axi_lite_awready(gp0_smc_M24_AXI_AWREADY),
        .s_axi_lite_awvalid(gp0_smc_M24_AXI_AWVALID),
        .s_axi_lite_bready(gp0_smc_M24_AXI_BREADY),
        .s_axi_lite_bresp(gp0_smc_M24_AXI_BRESP),
        .s_axi_lite_bvalid(gp0_smc_M24_AXI_BVALID),
        .s_axi_lite_rdata(gp0_smc_M24_AXI_RDATA),
        .s_axi_lite_rready(gp0_smc_M24_AXI_RREADY),
        .s_axi_lite_rresp(gp0_smc_M24_AXI_RRESP),
        .s_axi_lite_rvalid(gp0_smc_M24_AXI_RVALID),
        .s_axi_lite_wdata(gp0_smc_M24_AXI_WDATA),
        .s_axi_lite_wready(gp0_smc_M24_AXI_WREADY),
        .s_axi_lite_wvalid(gp0_smc_M24_AXI_WVALID),
        .s_axis_s2mm_tdata(return_source_M_AXIS_TDATA),
        .s_axis_s2mm_tkeep(return_source_M_AXIS_TKEEP),
        .s_axis_s2mm_tlast(return_source_M_AXIS_TLAST),
        .s_axis_s2mm_tready(return_source_M_AXIS_TREADY),
        .s_axis_s2mm_tvalid(return_source_M_AXIS_TVALID));
  c6v_return_source_0 return_source
       (.aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .busy(return_source_busy),
        .completed_byte_count(return_source_completed_byte_count),
        .completed_packet_count(return_source_completed_packet_count),
        .m_axis_tdata(return_source_M_AXIS_TDATA),
        .m_axis_tkeep(return_source_M_AXIS_TKEEP),
        .m_axis_tlast(return_source_M_AXIS_TLAST),
        .m_axis_tready(return_source_M_AXIS_TREADY),
        .m_axis_tvalid(return_source_M_AXIS_TVALID),
        .rejected_start_count(return_source_rejected_start_count),
        .requested_byte_count(return_control_gpio_gpio_io_o),
        .seed(return_control_gpio_gpio2_io_o),
        .start(return_start_gpio_gpio_io_o));
  c6v_return_start_gpio_0 return_start_gpio
       (.gpio_io_o(return_start_gpio_gpio_io_o),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M26_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M26_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M26_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M26_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M26_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M26_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M26_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M26_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M26_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M26_AXI_RDATA),
        .s_axi_rready(gp0_smc_M26_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M26_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M26_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M26_AXI_WDATA),
        .s_axi_wready(gp0_smc_M26_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M26_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M26_AXI_WVALID));
  c6v_return_state_gpio_0 return_state_gpio
       (.gpio2_io_i(return_source_rejected_start_count),
        .gpio_io_i(return_source_busy),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M28_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M28_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M28_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M28_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M28_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M28_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M28_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M28_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M28_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M28_AXI_RDATA),
        .s_axi_rready(gp0_smc_M28_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M28_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M28_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M28_AXI_WDATA),
        .s_axi_wready(gp0_smc_M28_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M28_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M28_AXI_WVALID));
  c6v_return_status_gpio_0 return_status_gpio
       (.gpio2_io_i(return_source_completed_packet_count),
        .gpio_io_i(return_source_completed_byte_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M27_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M27_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M27_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M27_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M27_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M27_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M27_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M27_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M27_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M27_AXI_RDATA),
        .s_axi_rready(gp0_smc_M27_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M27_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M27_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M27_AXI_WDATA),
        .s_axi_wready(gp0_smc_M27_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M27_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M27_AXI_WVALID));
  c6v_rgb2dvi_0 rgb2dvi
       (.PixelClk(pixel_clock_clk_out1),
        .TMDS_Clk_n(hdmi_out_clk_n),
        .TMDS_Clk_p(hdmi_out_clk_p),
        .TMDS_Data_n(hdmi_out_data_n),
        .TMDS_Data_p(hdmi_out_data_p),
        .aRst(rst_pixel_peripheral_reset),
        .vid_pData(input_osd_0_out_rgb),
        .vid_pHSync(input_osd_0_out_hs),
        .vid_pVDE(input_osd_0_out_de),
        .vid_pVSync(input_osd_0_out_vs));
  c6v_router_status_gpio_0 router_status_gpio
       (.gpio2_io_i(core_unsupported_packet_count),
        .gpio_io_i(core_router_dropped_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M14_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M14_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M14_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M14_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M14_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M14_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M14_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M14_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M14_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M14_AXI_RDATA),
        .s_axi_rready(gp0_smc_M14_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M14_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M14_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M14_AXI_WDATA),
        .s_axi_wready(gp0_smc_M14_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M14_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M14_AXI_WVALID));
  c6v_rst_fclk0_0 rst_fclk0
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(ps7_0_FCLK_RESET0_N),
        .interconnect_aresetn(rst_fclk0_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_fclk0_peripheral_aresetn),
        .peripheral_reset(rst_fclk0_peripheral_reset),
        .slowest_sync_clk(ps7_0_FCLK_CLK0));
  c6v_rst_pixel_0 rst_pixel
       (.aux_reset_in(1'b1),
        .dcm_locked(pixel_clock_locked),
        .ext_reset_in(ps7_0_FCLK_RESET0_N),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(rst_pixel_peripheral_aresetn),
        .peripheral_reset(rst_pixel_peripheral_reset),
        .slowest_sync_clk(pixel_clock_clk_out1));
  c6v_skin_hp3_smc_0 skin_hp3_smc
       (.M00_AXI_araddr(skin_hp3_smc_M00_AXI_ARADDR),
        .M00_AXI_arburst(skin_hp3_smc_M00_AXI_ARBURST),
        .M00_AXI_arcache(skin_hp3_smc_M00_AXI_ARCACHE),
        .M00_AXI_arlen(skin_hp3_smc_M00_AXI_ARLEN),
        .M00_AXI_arlock(skin_hp3_smc_M00_AXI_ARLOCK),
        .M00_AXI_arprot(skin_hp3_smc_M00_AXI_ARPROT),
        .M00_AXI_arqos(skin_hp3_smc_M00_AXI_ARQOS),
        .M00_AXI_arready(skin_hp3_smc_M00_AXI_ARREADY),
        .M00_AXI_arsize(skin_hp3_smc_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(skin_hp3_smc_M00_AXI_ARVALID),
        .M00_AXI_awaddr(skin_hp3_smc_M00_AXI_AWADDR),
        .M00_AXI_awburst(skin_hp3_smc_M00_AXI_AWBURST),
        .M00_AXI_awcache(skin_hp3_smc_M00_AXI_AWCACHE),
        .M00_AXI_awlen(skin_hp3_smc_M00_AXI_AWLEN),
        .M00_AXI_awlock(skin_hp3_smc_M00_AXI_AWLOCK),
        .M00_AXI_awprot(skin_hp3_smc_M00_AXI_AWPROT),
        .M00_AXI_awqos(skin_hp3_smc_M00_AXI_AWQOS),
        .M00_AXI_awready(skin_hp3_smc_M00_AXI_AWREADY),
        .M00_AXI_awsize(skin_hp3_smc_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(skin_hp3_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(skin_hp3_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(skin_hp3_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(skin_hp3_smc_M00_AXI_BVALID),
        .M00_AXI_rdata(skin_hp3_smc_M00_AXI_RDATA),
        .M00_AXI_rlast(skin_hp3_smc_M00_AXI_RLAST),
        .M00_AXI_rready(skin_hp3_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(skin_hp3_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(skin_hp3_smc_M00_AXI_RVALID),
        .M00_AXI_wdata(skin_hp3_smc_M00_AXI_WDATA),
        .M00_AXI_wlast(skin_hp3_smc_M00_AXI_WLAST),
        .M00_AXI_wready(skin_hp3_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(skin_hp3_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(skin_hp3_smc_M00_AXI_WVALID),
        .S00_AXI_awaddr(moments_dma_M_AXI_S2MM_AWADDR),
        .S00_AXI_awburst(moments_dma_M_AXI_S2MM_AWBURST),
        .S00_AXI_awcache(moments_dma_M_AXI_S2MM_AWCACHE),
        .S00_AXI_awlen(moments_dma_M_AXI_S2MM_AWLEN),
        .S00_AXI_awlock(1'b0),
        .S00_AXI_awprot(moments_dma_M_AXI_S2MM_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(moments_dma_M_AXI_S2MM_AWREADY),
        .S00_AXI_awsize(moments_dma_M_AXI_S2MM_AWSIZE),
        .S00_AXI_awvalid(moments_dma_M_AXI_S2MM_AWVALID),
        .S00_AXI_bready(moments_dma_M_AXI_S2MM_BREADY),
        .S00_AXI_bresp(moments_dma_M_AXI_S2MM_BRESP),
        .S00_AXI_bvalid(moments_dma_M_AXI_S2MM_BVALID),
        .S00_AXI_wdata(moments_dma_M_AXI_S2MM_WDATA),
        .S00_AXI_wlast(moments_dma_M_AXI_S2MM_WLAST),
        .S00_AXI_wready(moments_dma_M_AXI_S2MM_WREADY),
        .S00_AXI_wstrb(moments_dma_M_AXI_S2MM_WSTRB),
        .S00_AXI_wvalid(moments_dma_M_AXI_S2MM_WVALID),
        .S01_AXI_araddr(moments_dma_M_AXI_SG_ARADDR),
        .S01_AXI_arburst(moments_dma_M_AXI_SG_ARBURST),
        .S01_AXI_arcache(moments_dma_M_AXI_SG_ARCACHE),
        .S01_AXI_arlen(moments_dma_M_AXI_SG_ARLEN),
        .S01_AXI_arlock(1'b0),
        .S01_AXI_arprot(moments_dma_M_AXI_SG_ARPROT),
        .S01_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_arready(moments_dma_M_AXI_SG_ARREADY),
        .S01_AXI_arsize(moments_dma_M_AXI_SG_ARSIZE),
        .S01_AXI_arvalid(moments_dma_M_AXI_SG_ARVALID),
        .S01_AXI_awaddr(moments_dma_M_AXI_SG_AWADDR),
        .S01_AXI_awburst(moments_dma_M_AXI_SG_AWBURST),
        .S01_AXI_awcache(moments_dma_M_AXI_SG_AWCACHE),
        .S01_AXI_awlen(moments_dma_M_AXI_SG_AWLEN),
        .S01_AXI_awlock(1'b0),
        .S01_AXI_awprot(moments_dma_M_AXI_SG_AWPROT),
        .S01_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S01_AXI_awready(moments_dma_M_AXI_SG_AWREADY),
        .S01_AXI_awsize(moments_dma_M_AXI_SG_AWSIZE),
        .S01_AXI_awvalid(moments_dma_M_AXI_SG_AWVALID),
        .S01_AXI_bready(moments_dma_M_AXI_SG_BREADY),
        .S01_AXI_bresp(moments_dma_M_AXI_SG_BRESP),
        .S01_AXI_bvalid(moments_dma_M_AXI_SG_BVALID),
        .S01_AXI_rdata(moments_dma_M_AXI_SG_RDATA),
        .S01_AXI_rlast(moments_dma_M_AXI_SG_RLAST),
        .S01_AXI_rready(moments_dma_M_AXI_SG_RREADY),
        .S01_AXI_rresp(moments_dma_M_AXI_SG_RRESP),
        .S01_AXI_rvalid(moments_dma_M_AXI_SG_RVALID),
        .S01_AXI_wdata(moments_dma_M_AXI_SG_WDATA),
        .S01_AXI_wlast(moments_dma_M_AXI_SG_WLAST),
        .S01_AXI_wready(moments_dma_M_AXI_SG_WREADY),
        .S01_AXI_wstrb(moments_dma_M_AXI_SG_WSTRB),
        .S01_AXI_wvalid(moments_dma_M_AXI_SG_WVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_skin_reset_and_0 skin_reset_and
       (.Op1(rst_fclk0_peripheral_aresetn),
        .Op2(moments_reset_gpio_io_o),
        .Res(skin_reset_and_Res));
  c6v_tilemap_generation_status_gpio_0 tilemap_generation_status_gpio
       (.gpio2_io_i(core_tilemap_error_flags),
        .gpio_io_i(core_tilemap_generation),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M22_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M22_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M22_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M22_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M22_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M22_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M22_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M22_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M22_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M22_AXI_RDATA),
        .s_axi_rready(gp0_smc_M22_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M22_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M22_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M22_AXI_WDATA),
        .s_axi_wready(gp0_smc_M22_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M22_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M22_AXI_WVALID));
  c6v_tilemap_packet_status_gpio_0 tilemap_packet_status_gpio
       (.gpio2_io_i(core_tilemap_rejected_packet_count),
        .gpio_io_i(core_tilemap_accepted_packet_count),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M21_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M21_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M21_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M21_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M21_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M21_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M21_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M21_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M21_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M21_AXI_RDATA),
        .s_axi_rready(gp0_smc_M21_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M21_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M21_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M21_AXI_WDATA),
        .s_axi_wready(gp0_smc_M21_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M21_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M21_AXI_WVALID));
  c6v_tilemap_state_status_gpio_0 tilemap_state_status_gpio
       (.gpio_io_i(core_tilemap_status),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M23_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M23_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M23_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M23_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M23_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M23_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M23_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M23_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M23_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M23_AXI_RDATA),
        .s_axi_rready(gp0_smc_M23_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M23_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M23_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M23_AXI_WDATA),
        .s_axi_wready(gp0_smc_M23_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M23_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M23_AXI_WVALID));
  c6v_upload_status_gpio_0 upload_status_gpio
       (.gpio2_io_i(core_upload_byte_count),
        .gpio_io_i(core_upload_crc32),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M02_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arready(gp0_smc_M02_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M02_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M02_AXI_AWADDR),
        .s_axi_awready(gp0_smc_M02_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M02_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M02_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M02_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M02_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M02_AXI_RDATA),
        .s_axi_rready(gp0_smc_M02_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M02_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M02_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M02_AXI_WDATA),
        .s_axi_wready(gp0_smc_M02_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M02_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M02_AXI_WVALID));
  c6v_video_in_0 video_in
       (.aclk(ps7_0_FCLK_CLK0),
        .aclken(1'b1),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .axis_enable(capture_lifecycle_axis_enable),
        .m_axis_video_tdata(video_in_video_out_TDATA),
        .m_axis_video_tlast(video_in_video_out_TLAST),
        .m_axis_video_tready(video_in_video_out_TREADY),
        .m_axis_video_tuser(video_in_video_out_TUSER),
        .m_axis_video_tvalid(video_in_video_out_TVALID),
        .overflow(video_in_overflow),
        .underflow(video_in_underflow),
        .vid_active_video(vid_hsync),
        .vid_data(vid_data),
        .vid_field_id(1'b0),
        .vid_hblank(1'b0),
        .vid_hsync(1'b0),
        .vid_io_in_ce(1'b1),
        .vid_io_in_clk(vid_pclk),
        .vid_io_in_reset(1'b0),
        .vid_vblank(1'b0),
        .vid_vsync(vid_vsync));
  c6v_vision_control_smc_0 vision_control_smc
       (.M00_AXI_araddr(vision_control_smc_M00_AXI_ARADDR),
        .M00_AXI_arready(vision_control_smc_M00_AXI_ARREADY),
        .M00_AXI_arvalid(vision_control_smc_M00_AXI_ARVALID),
        .M00_AXI_awaddr(vision_control_smc_M00_AXI_AWADDR),
        .M00_AXI_awready(vision_control_smc_M00_AXI_AWREADY),
        .M00_AXI_awvalid(vision_control_smc_M00_AXI_AWVALID),
        .M00_AXI_bready(vision_control_smc_M00_AXI_BREADY),
        .M00_AXI_bresp(vision_control_smc_M00_AXI_BRESP),
        .M00_AXI_bvalid(vision_control_smc_M00_AXI_BVALID),
        .M00_AXI_rdata(vision_control_smc_M00_AXI_RDATA),
        .M00_AXI_rready(vision_control_smc_M00_AXI_RREADY),
        .M00_AXI_rresp(vision_control_smc_M00_AXI_RRESP),
        .M00_AXI_rvalid(vision_control_smc_M00_AXI_RVALID),
        .M00_AXI_wdata(vision_control_smc_M00_AXI_WDATA),
        .M00_AXI_wready(vision_control_smc_M00_AXI_WREADY),
        .M00_AXI_wstrb(vision_control_smc_M00_AXI_WSTRB),
        .M00_AXI_wvalid(vision_control_smc_M00_AXI_WVALID),
        .M01_AXI_araddr(vision_control_smc_M01_AXI_ARADDR),
        .M01_AXI_arready(vision_control_smc_M01_AXI_ARREADY),
        .M01_AXI_arvalid(vision_control_smc_M01_AXI_ARVALID),
        .M01_AXI_awaddr(vision_control_smc_M01_AXI_AWADDR),
        .M01_AXI_awready(vision_control_smc_M01_AXI_AWREADY),
        .M01_AXI_awvalid(vision_control_smc_M01_AXI_AWVALID),
        .M01_AXI_bready(vision_control_smc_M01_AXI_BREADY),
        .M01_AXI_bresp(vision_control_smc_M01_AXI_BRESP),
        .M01_AXI_bvalid(vision_control_smc_M01_AXI_BVALID),
        .M01_AXI_rdata(vision_control_smc_M01_AXI_RDATA),
        .M01_AXI_rready(vision_control_smc_M01_AXI_RREADY),
        .M01_AXI_rresp(vision_control_smc_M01_AXI_RRESP),
        .M01_AXI_rvalid(vision_control_smc_M01_AXI_RVALID),
        .M01_AXI_wdata(vision_control_smc_M01_AXI_WDATA),
        .M01_AXI_wready(vision_control_smc_M01_AXI_WREADY),
        .M01_AXI_wstrb(vision_control_smc_M01_AXI_WSTRB),
        .M01_AXI_wvalid(vision_control_smc_M01_AXI_WVALID),
        .M02_AXI_araddr(vision_control_smc_M02_AXI_ARADDR),
        .M02_AXI_arready(vision_control_smc_M02_AXI_ARREADY),
        .M02_AXI_arvalid(vision_control_smc_M02_AXI_ARVALID),
        .M02_AXI_awaddr(vision_control_smc_M02_AXI_AWADDR),
        .M02_AXI_awready(vision_control_smc_M02_AXI_AWREADY),
        .M02_AXI_awvalid(vision_control_smc_M02_AXI_AWVALID),
        .M02_AXI_bready(vision_control_smc_M02_AXI_BREADY),
        .M02_AXI_bresp(vision_control_smc_M02_AXI_BRESP),
        .M02_AXI_bvalid(vision_control_smc_M02_AXI_BVALID),
        .M02_AXI_rdata(vision_control_smc_M02_AXI_RDATA),
        .M02_AXI_rready(vision_control_smc_M02_AXI_RREADY),
        .M02_AXI_rresp(vision_control_smc_M02_AXI_RRESP),
        .M02_AXI_rvalid(vision_control_smc_M02_AXI_RVALID),
        .M02_AXI_wdata(vision_control_smc_M02_AXI_WDATA),
        .M02_AXI_wready(vision_control_smc_M02_AXI_WREADY),
        .M02_AXI_wvalid(vision_control_smc_M02_AXI_WVALID),
        .M03_AXI_araddr(vision_control_smc_M03_AXI_ARADDR),
        .M03_AXI_arready(vision_control_smc_M03_AXI_ARREADY),
        .M03_AXI_arvalid(vision_control_smc_M03_AXI_ARVALID),
        .M03_AXI_awaddr(vision_control_smc_M03_AXI_AWADDR),
        .M03_AXI_awready(vision_control_smc_M03_AXI_AWREADY),
        .M03_AXI_awvalid(vision_control_smc_M03_AXI_AWVALID),
        .M03_AXI_bready(vision_control_smc_M03_AXI_BREADY),
        .M03_AXI_bresp(vision_control_smc_M03_AXI_BRESP),
        .M03_AXI_bvalid(vision_control_smc_M03_AXI_BVALID),
        .M03_AXI_rdata(vision_control_smc_M03_AXI_RDATA),
        .M03_AXI_rready(vision_control_smc_M03_AXI_RREADY),
        .M03_AXI_rresp(vision_control_smc_M03_AXI_RRESP),
        .M03_AXI_rvalid(vision_control_smc_M03_AXI_RVALID),
        .M03_AXI_wdata(vision_control_smc_M03_AXI_WDATA),
        .M03_AXI_wready(vision_control_smc_M03_AXI_WREADY),
        .M03_AXI_wvalid(vision_control_smc_M03_AXI_WVALID),
        .M04_AXI_araddr(vision_control_smc_M04_AXI_ARADDR),
        .M04_AXI_arready(vision_control_smc_M04_AXI_ARREADY),
        .M04_AXI_arvalid(vision_control_smc_M04_AXI_ARVALID),
        .M04_AXI_awaddr(vision_control_smc_M04_AXI_AWADDR),
        .M04_AXI_awready(vision_control_smc_M04_AXI_AWREADY),
        .M04_AXI_awvalid(vision_control_smc_M04_AXI_AWVALID),
        .M04_AXI_bready(vision_control_smc_M04_AXI_BREADY),
        .M04_AXI_bresp(vision_control_smc_M04_AXI_BRESP),
        .M04_AXI_bvalid(vision_control_smc_M04_AXI_BVALID),
        .M04_AXI_rdata(vision_control_smc_M04_AXI_RDATA),
        .M04_AXI_rready(vision_control_smc_M04_AXI_RREADY),
        .M04_AXI_rresp(vision_control_smc_M04_AXI_RRESP),
        .M04_AXI_rvalid(vision_control_smc_M04_AXI_RVALID),
        .M04_AXI_wdata(vision_control_smc_M04_AXI_WDATA),
        .M04_AXI_wready(vision_control_smc_M04_AXI_WREADY),
        .M04_AXI_wstrb(vision_control_smc_M04_AXI_WSTRB),
        .M04_AXI_wvalid(vision_control_smc_M04_AXI_WVALID),
        .M05_AXI_araddr(vision_control_smc_M05_AXI_ARADDR),
        .M05_AXI_arprot(vision_control_smc_M05_AXI_ARPROT),
        .M05_AXI_arready(vision_control_smc_M05_AXI_ARREADY),
        .M05_AXI_arvalid(vision_control_smc_M05_AXI_ARVALID),
        .M05_AXI_awaddr(vision_control_smc_M05_AXI_AWADDR),
        .M05_AXI_awprot(vision_control_smc_M05_AXI_AWPROT),
        .M05_AXI_awready(vision_control_smc_M05_AXI_AWREADY),
        .M05_AXI_awvalid(vision_control_smc_M05_AXI_AWVALID),
        .M05_AXI_bready(vision_control_smc_M05_AXI_BREADY),
        .M05_AXI_bresp(vision_control_smc_M05_AXI_BRESP),
        .M05_AXI_bvalid(vision_control_smc_M05_AXI_BVALID),
        .M05_AXI_rdata(vision_control_smc_M05_AXI_RDATA),
        .M05_AXI_rready(vision_control_smc_M05_AXI_RREADY),
        .M05_AXI_rresp(vision_control_smc_M05_AXI_RRESP),
        .M05_AXI_rvalid(vision_control_smc_M05_AXI_RVALID),
        .M05_AXI_wdata(vision_control_smc_M05_AXI_WDATA),
        .M05_AXI_wready(vision_control_smc_M05_AXI_WREADY),
        .M05_AXI_wstrb(vision_control_smc_M05_AXI_WSTRB),
        .M05_AXI_wvalid(vision_control_smc_M05_AXI_WVALID),
        .M06_AXI_araddr(vision_control_smc_M06_AXI_ARADDR),
        .M06_AXI_arready(vision_control_smc_M06_AXI_ARREADY),
        .M06_AXI_arvalid(vision_control_smc_M06_AXI_ARVALID),
        .M06_AXI_awaddr(vision_control_smc_M06_AXI_AWADDR),
        .M06_AXI_awready(vision_control_smc_M06_AXI_AWREADY),
        .M06_AXI_awvalid(vision_control_smc_M06_AXI_AWVALID),
        .M06_AXI_bready(vision_control_smc_M06_AXI_BREADY),
        .M06_AXI_bresp(vision_control_smc_M06_AXI_BRESP),
        .M06_AXI_bvalid(vision_control_smc_M06_AXI_BVALID),
        .M06_AXI_rdata(vision_control_smc_M06_AXI_RDATA),
        .M06_AXI_rready(vision_control_smc_M06_AXI_RREADY),
        .M06_AXI_rresp(vision_control_smc_M06_AXI_RRESP),
        .M06_AXI_rvalid(vision_control_smc_M06_AXI_RVALID),
        .M06_AXI_wdata(vision_control_smc_M06_AXI_WDATA),
        .M06_AXI_wready(vision_control_smc_M06_AXI_WREADY),
        .M06_AXI_wstrb(vision_control_smc_M06_AXI_WSTRB),
        .M06_AXI_wvalid(vision_control_smc_M06_AXI_WVALID),
        .M07_AXI_araddr(vision_control_smc_M07_AXI_ARADDR),
        .M07_AXI_arready(vision_control_smc_M07_AXI_ARREADY),
        .M07_AXI_arvalid(vision_control_smc_M07_AXI_ARVALID),
        .M07_AXI_awaddr(vision_control_smc_M07_AXI_AWADDR),
        .M07_AXI_awready(vision_control_smc_M07_AXI_AWREADY),
        .M07_AXI_awvalid(vision_control_smc_M07_AXI_AWVALID),
        .M07_AXI_bready(vision_control_smc_M07_AXI_BREADY),
        .M07_AXI_bresp(vision_control_smc_M07_AXI_BRESP),
        .M07_AXI_bvalid(vision_control_smc_M07_AXI_BVALID),
        .M07_AXI_rdata(vision_control_smc_M07_AXI_RDATA),
        .M07_AXI_rready(vision_control_smc_M07_AXI_RREADY),
        .M07_AXI_rresp(vision_control_smc_M07_AXI_RRESP),
        .M07_AXI_rvalid(vision_control_smc_M07_AXI_RVALID),
        .M07_AXI_wdata(vision_control_smc_M07_AXI_WDATA),
        .M07_AXI_wready(vision_control_smc_M07_AXI_WREADY),
        .M07_AXI_wstrb(vision_control_smc_M07_AXI_WSTRB),
        .M07_AXI_wvalid(vision_control_smc_M07_AXI_WVALID),
        .S00_AXI_araddr(gp0_smc_M29_AXI_ARADDR),
        .S00_AXI_arburst(gp0_smc_M29_AXI_ARBURST),
        .S00_AXI_arcache(gp0_smc_M29_AXI_ARCACHE),
        .S00_AXI_arid(gp0_smc_M29_AXI_ARID),
        .S00_AXI_arlen(gp0_smc_M29_AXI_ARLEN),
        .S00_AXI_arlock(gp0_smc_M29_AXI_ARLOCK),
        .S00_AXI_arprot(gp0_smc_M29_AXI_ARPROT),
        .S00_AXI_arqos(gp0_smc_M29_AXI_ARQOS),
        .S00_AXI_arready(gp0_smc_M29_AXI_ARREADY),
        .S00_AXI_arsize(gp0_smc_M29_AXI_ARSIZE),
        .S00_AXI_aruser(gp0_smc_M29_AXI_ARUSER),
        .S00_AXI_arvalid(gp0_smc_M29_AXI_ARVALID),
        .S00_AXI_awaddr(gp0_smc_M29_AXI_AWADDR),
        .S00_AXI_awburst(gp0_smc_M29_AXI_AWBURST),
        .S00_AXI_awcache(gp0_smc_M29_AXI_AWCACHE),
        .S00_AXI_awid(gp0_smc_M29_AXI_AWID),
        .S00_AXI_awlen(gp0_smc_M29_AXI_AWLEN),
        .S00_AXI_awlock(gp0_smc_M29_AXI_AWLOCK),
        .S00_AXI_awprot(gp0_smc_M29_AXI_AWPROT),
        .S00_AXI_awqos(gp0_smc_M29_AXI_AWQOS),
        .S00_AXI_awready(gp0_smc_M29_AXI_AWREADY),
        .S00_AXI_awsize(gp0_smc_M29_AXI_AWSIZE),
        .S00_AXI_awuser(gp0_smc_M29_AXI_AWUSER),
        .S00_AXI_awvalid(gp0_smc_M29_AXI_AWVALID),
        .S00_AXI_bid(gp0_smc_M29_AXI_BID),
        .S00_AXI_bready(gp0_smc_M29_AXI_BREADY),
        .S00_AXI_bresp(gp0_smc_M29_AXI_BRESP),
        .S00_AXI_bvalid(gp0_smc_M29_AXI_BVALID),
        .S00_AXI_rdata(gp0_smc_M29_AXI_RDATA),
        .S00_AXI_rid(gp0_smc_M29_AXI_RID),
        .S00_AXI_rlast(gp0_smc_M29_AXI_RLAST),
        .S00_AXI_rready(gp0_smc_M29_AXI_RREADY),
        .S00_AXI_rresp(gp0_smc_M29_AXI_RRESP),
        .S00_AXI_ruser(gp0_smc_M29_AXI_RUSER),
        .S00_AXI_rvalid(gp0_smc_M29_AXI_RVALID),
        .S00_AXI_wdata(gp0_smc_M29_AXI_WDATA),
        .S00_AXI_wlast(gp0_smc_M29_AXI_WLAST),
        .S00_AXI_wready(gp0_smc_M29_AXI_WREADY),
        .S00_AXI_wstrb(gp0_smc_M29_AXI_WSTRB),
        .S00_AXI_wuser(gp0_smc_M29_AXI_WUSER),
        .S00_AXI_wvalid(gp0_smc_M29_AXI_WVALID),
        .aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_interconnect_aresetn));
  c6v_vision_gp0_slice_0 vision_gp0_slice
       (.aclk(ps7_0_FCLK_CLK0),
        .aresetn(rst_fclk0_peripheral_aresetn),
        .m_axi_araddr(vision_gp0_slice_M_AXI_ARADDR),
        .m_axi_arburst(vision_gp0_slice_M_AXI_ARBURST),
        .m_axi_arcache(vision_gp0_slice_M_AXI_ARCACHE),
        .m_axi_arid(vision_gp0_slice_M_AXI_ARID),
        .m_axi_arlen(vision_gp0_slice_M_AXI_ARLEN),
        .m_axi_arlock(vision_gp0_slice_M_AXI_ARLOCK),
        .m_axi_arprot(vision_gp0_slice_M_AXI_ARPROT),
        .m_axi_arqos(vision_gp0_slice_M_AXI_ARQOS),
        .m_axi_arready(vision_gp0_slice_M_AXI_ARREADY),
        .m_axi_arsize(vision_gp0_slice_M_AXI_ARSIZE),
        .m_axi_arvalid(vision_gp0_slice_M_AXI_ARVALID),
        .m_axi_awaddr(vision_gp0_slice_M_AXI_AWADDR),
        .m_axi_awburst(vision_gp0_slice_M_AXI_AWBURST),
        .m_axi_awcache(vision_gp0_slice_M_AXI_AWCACHE),
        .m_axi_awid(vision_gp0_slice_M_AXI_AWID),
        .m_axi_awlen(vision_gp0_slice_M_AXI_AWLEN),
        .m_axi_awlock(vision_gp0_slice_M_AXI_AWLOCK),
        .m_axi_awprot(vision_gp0_slice_M_AXI_AWPROT),
        .m_axi_awqos(vision_gp0_slice_M_AXI_AWQOS),
        .m_axi_awready(vision_gp0_slice_M_AXI_AWREADY),
        .m_axi_awsize(vision_gp0_slice_M_AXI_AWSIZE),
        .m_axi_awvalid(vision_gp0_slice_M_AXI_AWVALID),
        .m_axi_bid(vision_gp0_slice_M_AXI_BID),
        .m_axi_bready(vision_gp0_slice_M_AXI_BREADY),
        .m_axi_bresp(vision_gp0_slice_M_AXI_BRESP),
        .m_axi_bvalid(vision_gp0_slice_M_AXI_BVALID),
        .m_axi_rdata(vision_gp0_slice_M_AXI_RDATA),
        .m_axi_rid(vision_gp0_slice_M_AXI_RID),
        .m_axi_rlast(vision_gp0_slice_M_AXI_RLAST),
        .m_axi_rready(vision_gp0_slice_M_AXI_RREADY),
        .m_axi_rresp(vision_gp0_slice_M_AXI_RRESP),
        .m_axi_rvalid(vision_gp0_slice_M_AXI_RVALID),
        .m_axi_wdata(vision_gp0_slice_M_AXI_WDATA),
        .m_axi_wid(vision_gp0_slice_M_AXI_WID),
        .m_axi_wlast(vision_gp0_slice_M_AXI_WLAST),
        .m_axi_wready(vision_gp0_slice_M_AXI_WREADY),
        .m_axi_wstrb(vision_gp0_slice_M_AXI_WSTRB),
        .m_axi_wvalid(vision_gp0_slice_M_AXI_WVALID),
        .s_axi_araddr(ps7_0_M_AXI_GP0_ARADDR),
        .s_axi_arburst(ps7_0_M_AXI_GP0_ARBURST),
        .s_axi_arcache(ps7_0_M_AXI_GP0_ARCACHE),
        .s_axi_arid(ps7_0_M_AXI_GP0_ARID),
        .s_axi_arlen(ps7_0_M_AXI_GP0_ARLEN),
        .s_axi_arlock(ps7_0_M_AXI_GP0_ARLOCK),
        .s_axi_arprot(ps7_0_M_AXI_GP0_ARPROT),
        .s_axi_arqos(ps7_0_M_AXI_GP0_ARQOS),
        .s_axi_arready(ps7_0_M_AXI_GP0_ARREADY),
        .s_axi_arsize(ps7_0_M_AXI_GP0_ARSIZE),
        .s_axi_arvalid(ps7_0_M_AXI_GP0_ARVALID),
        .s_axi_awaddr(ps7_0_M_AXI_GP0_AWADDR),
        .s_axi_awburst(ps7_0_M_AXI_GP0_AWBURST),
        .s_axi_awcache(ps7_0_M_AXI_GP0_AWCACHE),
        .s_axi_awid(ps7_0_M_AXI_GP0_AWID),
        .s_axi_awlen(ps7_0_M_AXI_GP0_AWLEN),
        .s_axi_awlock(ps7_0_M_AXI_GP0_AWLOCK),
        .s_axi_awprot(ps7_0_M_AXI_GP0_AWPROT),
        .s_axi_awqos(ps7_0_M_AXI_GP0_AWQOS),
        .s_axi_awready(ps7_0_M_AXI_GP0_AWREADY),
        .s_axi_awsize(ps7_0_M_AXI_GP0_AWSIZE),
        .s_axi_awvalid(ps7_0_M_AXI_GP0_AWVALID),
        .s_axi_bid(ps7_0_M_AXI_GP0_BID),
        .s_axi_bready(ps7_0_M_AXI_GP0_BREADY),
        .s_axi_bresp(ps7_0_M_AXI_GP0_BRESP),
        .s_axi_bvalid(ps7_0_M_AXI_GP0_BVALID),
        .s_axi_rdata(ps7_0_M_AXI_GP0_RDATA),
        .s_axi_rid(ps7_0_M_AXI_GP0_RID),
        .s_axi_rlast(ps7_0_M_AXI_GP0_RLAST),
        .s_axi_rready(ps7_0_M_AXI_GP0_RREADY),
        .s_axi_rresp(ps7_0_M_AXI_GP0_RRESP),
        .s_axi_rvalid(ps7_0_M_AXI_GP0_RVALID),
        .s_axi_wdata(ps7_0_M_AXI_GP0_WDATA),
        .s_axi_wid(ps7_0_M_AXI_GP0_WID),
        .s_axi_wlast(ps7_0_M_AXI_GP0_WLAST),
        .s_axi_wready(ps7_0_M_AXI_GP0_WREADY),
        .s_axi_wstrb(ps7_0_M_AXI_GP0_WSTRB),
        .s_axi_wvalid(ps7_0_M_AXI_GP0_WVALID));
  c6v_voice_volume_0_0 voice_volume_0
       (.codec_address(codec_address),
        .codec_mclk_locked(audio_mclk_locked),
        .i2s_bclk(bclk),
        .i2s_lrclk(lrclk),
        .i2s_sdata(sdata_i),
        .s_axi_aclk(ps7_0_FCLK_CLK0),
        .s_axi_araddr(gp0_smc_M30_AXI_ARADDR),
        .s_axi_aresetn(rst_fclk0_peripheral_aresetn),
        .s_axi_arprot(gp0_smc_M30_AXI_ARPROT),
        .s_axi_arready(gp0_smc_M30_AXI_ARREADY),
        .s_axi_arvalid(gp0_smc_M30_AXI_ARVALID),
        .s_axi_awaddr(gp0_smc_M30_AXI_AWADDR),
        .s_axi_awprot(gp0_smc_M30_AXI_AWPROT),
        .s_axi_awready(gp0_smc_M30_AXI_AWREADY),
        .s_axi_awvalid(gp0_smc_M30_AXI_AWVALID),
        .s_axi_bready(gp0_smc_M30_AXI_BREADY),
        .s_axi_bresp(gp0_smc_M30_AXI_BRESP),
        .s_axi_bvalid(gp0_smc_M30_AXI_BVALID),
        .s_axi_rdata(gp0_smc_M30_AXI_RDATA),
        .s_axi_rready(gp0_smc_M30_AXI_RREADY),
        .s_axi_rresp(gp0_smc_M30_AXI_RRESP),
        .s_axi_rvalid(gp0_smc_M30_AXI_RVALID),
        .s_axi_wdata(gp0_smc_M30_AXI_WDATA),
        .s_axi_wready(gp0_smc_M30_AXI_WREADY),
        .s_axi_wstrb(gp0_smc_M30_AXI_WSTRB),
        .s_axi_wvalid(gp0_smc_M30_AXI_WVALID));
  c6v_volume_zero_0 volume_zero
       (.dout(sdata_o));
endmodule
