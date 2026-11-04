// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2026.1 (win64) Build 6511674 Tue Jun 16 11:02:23 MDT 2026
// Date        : Thu Oct 22 03:24:04 2026
// Host        : DESKTOP-JBJOBKD running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top c6v_return_state_gpio_0 -prefix
//               c6v_return_state_gpio_0_ c6v_return_state_gpio_0_sim_netlist.v
// Design      : c6v_return_state_gpio_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module c6v_return_state_gpio_0_GPIO_Core
   (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ,
    GPIO_xferAck_i,
    gpio_xferAck_Reg,
    gpio_Data_In,
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ,
    \Dual.gpio_OE_reg[0]_0 ,
    ip2bus_wrack_i,
    ip2bus_rdack_i,
    Q,
    \Dual.gpio2_Data_In_reg[0]_0 ,
    gpio_io_i,
    s_axi_aclk,
    gpio2_io_i,
    \Dual.Read_Reg2_In ,
    bus2ip_reset,
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0 ,
    \Dual.gpio_OE_reg[0]_1 ,
    bus2ip_cs,
    bus2ip_rnw,
    E,
    D);
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  output \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  output GPIO_xferAck_i;
  output gpio_xferAck_Reg;
  output [0:0]gpio_Data_In;
  output \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  output \Dual.gpio_OE_reg[0]_0 ;
  output ip2bus_wrack_i;
  output ip2bus_rdack_i;
  output [31:0]Q;
  output [31:0]\Dual.gpio2_Data_In_reg[0]_0 ;
  input [0:0]gpio_io_i;
  input s_axi_aclk;
  input [31:0]gpio2_io_i;
  input [0:31]\Dual.Read_Reg2_In ;
  input bus2ip_reset;
  input \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0 ;
  input \Dual.gpio_OE_reg[0]_1 ;
  input [0:0]bus2ip_cs;
  input bus2ip_rnw;
  input [0:0]E;
  input [31:0]D;

  wire [31:0]D;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0 ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  wire [0:31]\Dual.Read_Reg2_In ;
  wire [31:0]\Dual.gpio2_Data_In_reg[0]_0 ;
  wire [0:31]\Dual.gpio2_io_i_d2 ;
  wire \Dual.gpio_OE_reg[0]_0 ;
  wire \Dual.gpio_OE_reg[0]_1 ;
  wire [0:0]E;
  wire GPIO_xferAck_i;
  wire [31:0]Q;
  wire Read_Reg_Rst;
  wire [0:0]bus2ip_cs;
  wire bus2ip_reset;
  wire bus2ip_rnw;
  wire [31:0]gpio2_io_i;
  wire [0:0]gpio_Data_In;
  wire [0:0]gpio_io_i;
  wire [0:0]gpio_io_i_d2;
  wire gpio_xferAck_Reg;
  wire iGPIO_xferAck;
  wire ip2bus_rdack_i;
  wire ip2bus_wrack_i;
  wire s_axi_aclk;

  FDRE \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0 ),
        .Q(\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .R(1'b0));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [0]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [10]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg[11] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [11]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [12]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [13]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg[14] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [14]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg[15] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [15]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg[16] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [16]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg[17] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [17]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg[18] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [18]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg[19] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [19]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [1]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg[20] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [20]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg[21] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [21]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg[22] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [22]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg[23] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [23]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg[24] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [24]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg[25] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [25]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg[26] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [26]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg[27] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [27]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg[28] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [28]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg[29] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [29]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [2]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg[30] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [30]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .R(Read_Reg_Rst));
  LUT4 #(
    .INIT(16'hEFFF)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3[31]_i_1 
       (.I0(GPIO_xferAck_i),
        .I1(gpio_xferAck_Reg),
        .I2(bus2ip_cs),
        .I3(bus2ip_rnw),
        .O(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg[31] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [31]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [3]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [4]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [5]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [6]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [7]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [8]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .R(Read_Reg_Rst));
  FDRE \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.Read_Reg2_In [9]),
        .Q(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .R(Read_Reg_Rst));
  (* DEST_SYNC_FF = "4" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SRC_INPUT_REG = "0" *) 
  (* VERSION = "0" *) 
  (* WIDTH = "1" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_return_state_gpio_0_xpm_cdc_array_single \Dual.INPUT_DOUBLE_REGS4 
       (.dest_clk(s_axi_aclk),
        .dest_out(gpio_io_i_d2),
        .src_clk(1'b0),
        .src_in(gpio_io_i));
  (* DEST_SYNC_FF = "4" *) 
  (* INIT_SYNC_FF = "0" *) 
  (* SIM_ASSERT_CHK = "0" *) 
  (* SRC_INPUT_REG = "0" *) 
  (* VERSION = "0" *) 
  (* WIDTH = "32" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  (* XPM_MODULE = "TRUE" *) 
  c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1 \Dual.INPUT_DOUBLE_REGS5 
       (.dest_clk(s_axi_aclk),
        .dest_out({\Dual.gpio2_io_i_d2 [0],\Dual.gpio2_io_i_d2 [1],\Dual.gpio2_io_i_d2 [2],\Dual.gpio2_io_i_d2 [3],\Dual.gpio2_io_i_d2 [4],\Dual.gpio2_io_i_d2 [5],\Dual.gpio2_io_i_d2 [6],\Dual.gpio2_io_i_d2 [7],\Dual.gpio2_io_i_d2 [8],\Dual.gpio2_io_i_d2 [9],\Dual.gpio2_io_i_d2 [10],\Dual.gpio2_io_i_d2 [11],\Dual.gpio2_io_i_d2 [12],\Dual.gpio2_io_i_d2 [13],\Dual.gpio2_io_i_d2 [14],\Dual.gpio2_io_i_d2 [15],\Dual.gpio2_io_i_d2 [16],\Dual.gpio2_io_i_d2 [17],\Dual.gpio2_io_i_d2 [18],\Dual.gpio2_io_i_d2 [19],\Dual.gpio2_io_i_d2 [20],\Dual.gpio2_io_i_d2 [21],\Dual.gpio2_io_i_d2 [22],\Dual.gpio2_io_i_d2 [23],\Dual.gpio2_io_i_d2 [24],\Dual.gpio2_io_i_d2 [25],\Dual.gpio2_io_i_d2 [26],\Dual.gpio2_io_i_d2 [27],\Dual.gpio2_io_i_d2 [28],\Dual.gpio2_io_i_d2 [29],\Dual.gpio2_io_i_d2 [30],\Dual.gpio2_io_i_d2 [31]}),
        .src_clk(1'b0),
        .src_in(gpio2_io_i));
  FDRE \Dual.gpio2_Data_In_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [0]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [31]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [10]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [21]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[11] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [11]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [20]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [12]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [19]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [13]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [18]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[14] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [14]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [17]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[15] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [15]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [16]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[16] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [16]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [15]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[17] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [17]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [14]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[18] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [18]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [13]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[19] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [19]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [12]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [1]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [30]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[20] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [20]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [11]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[21] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [21]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [10]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[22] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [22]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [9]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[23] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [23]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [8]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[24] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [24]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [7]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[25] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [25]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [6]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[26] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [26]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [5]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[27] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [27]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [4]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[28] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [28]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [3]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[29] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [29]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [2]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [2]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [29]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[30] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [30]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [1]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[31] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [31]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [0]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [3]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [28]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [4]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [27]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [5]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [26]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [6]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [25]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [7]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [24]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [8]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [23]),
        .R(1'b0));
  FDRE \Dual.gpio2_Data_In_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio2_io_i_d2 [9]),
        .Q(\Dual.gpio2_Data_In_reg[0]_0 [22]),
        .R(1'b0));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[0] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[31]),
        .Q(Q[31]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[10] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[21]),
        .Q(Q[21]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[11] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[20]),
        .Q(Q[20]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[12] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[19]),
        .Q(Q[19]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[13] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[18]),
        .Q(Q[18]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[14] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[17]),
        .Q(Q[17]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[15] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[16]),
        .Q(Q[16]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[16] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[15]),
        .Q(Q[15]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[17] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[14]),
        .Q(Q[14]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[18] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[13]),
        .Q(Q[13]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[19] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[12]),
        .Q(Q[12]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[1] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[30]),
        .Q(Q[30]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[20] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[11]),
        .Q(Q[11]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[21] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[10]),
        .Q(Q[10]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[22] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[9]),
        .Q(Q[9]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[23] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[8]),
        .Q(Q[8]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[24] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[7]),
        .Q(Q[7]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[25] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[6]),
        .Q(Q[6]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[26] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[5]),
        .Q(Q[5]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[27] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[4]),
        .Q(Q[4]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[28] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[3]),
        .Q(Q[3]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[29] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[2]),
        .Q(Q[2]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[2] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[29]),
        .Q(Q[29]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[30] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[1]),
        .Q(Q[1]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[31] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[0]),
        .Q(Q[0]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[3] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[28]),
        .Q(Q[28]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[4] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[27]),
        .Q(Q[27]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[5] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[26]),
        .Q(Q[26]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[6] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[25]),
        .Q(Q[25]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[7] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[24]),
        .Q(Q[24]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[8] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[23]),
        .Q(Q[23]),
        .S(bus2ip_reset));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio2_OE_reg[9] 
       (.C(s_axi_aclk),
        .CE(E),
        .D(D[22]),
        .Q(Q[22]),
        .S(bus2ip_reset));
  FDRE \Dual.gpio_Data_In_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(gpio_io_i_d2),
        .Q(gpio_Data_In),
        .R(1'b0));
  FDSE #(
    .INIT(1'b1)) 
    \Dual.gpio_OE_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\Dual.gpio_OE_reg[0]_1 ),
        .Q(\Dual.gpio_OE_reg[0]_0 ),
        .S(bus2ip_reset));
  FDRE gpio_xferAck_Reg_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(GPIO_xferAck_i),
        .Q(gpio_xferAck_Reg),
        .R(bus2ip_reset));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'h04)) 
    iGPIO_xferAck_i_1
       (.I0(gpio_xferAck_Reg),
        .I1(bus2ip_cs),
        .I2(GPIO_xferAck_i),
        .O(iGPIO_xferAck));
  FDRE iGPIO_xferAck_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(iGPIO_xferAck),
        .Q(GPIO_xferAck_i),
        .R(bus2ip_reset));
  LUT2 #(
    .INIT(4'h8)) 
    ip2bus_rdack_i_D1_i_1
       (.I0(GPIO_xferAck_i),
        .I1(bus2ip_rnw),
        .O(ip2bus_rdack_i));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT2 #(
    .INIT(4'h2)) 
    ip2bus_wrack_i_D1_i_1
       (.I0(GPIO_xferAck_i),
        .I1(bus2ip_rnw),
        .O(ip2bus_wrack_i));
endmodule

module c6v_return_state_gpio_0_address_decoder
   (\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ,
    \Dual.gpio_Data_In_reg[0] ,
    D,
    E,
    s_axi_wdata_0_sp_1,
    ip2bus_rdack_i_D1_reg,
    ip2bus_wrack_i_D1_reg,
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 ,
    Q,
    s_axi_aclk,
    \Dual.gpio2_OE_reg[0] ,
    Bus_RNW_reg_reg_0,
    gpio_Data_In,
    \Dual.gpio_OE_reg[0] ,
    gpio_xferAck_Reg,
    GPIO_xferAck_i,
    s_axi_wdata,
    s_axi_aresetn,
    ip2bus_rdack_i_D1,
    s_axi_arready,
    s_axi_arready_0,
    ip2bus_wrack_i_D1,
    s_axi_awready,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ,
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg );
  output \MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ;
  output \Dual.gpio_Data_In_reg[0] ;
  output [31:0]D;
  output [0:0]E;
  output s_axi_wdata_0_sp_1;
  output ip2bus_rdack_i_D1_reg;
  output ip2bus_wrack_i_D1_reg;
  output [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 ;
  input Q;
  input s_axi_aclk;
  input [2:0]\Dual.gpio2_OE_reg[0] ;
  input Bus_RNW_reg_reg_0;
  input [0:0]gpio_Data_In;
  input \Dual.gpio_OE_reg[0] ;
  input gpio_xferAck_Reg;
  input GPIO_xferAck_i;
  input [31:0]s_axi_wdata;
  input s_axi_aresetn;
  input ip2bus_rdack_i_D1;
  input s_axi_arready;
  input [3:0]s_axi_arready_0;
  input ip2bus_wrack_i_D1;
  input s_axi_awready;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  input \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;

  wire Bus_RNW_reg;
  wire Bus_RNW_reg_i_1_n_0;
  wire Bus_RNW_reg_reg_0;
  wire [31:0]D;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0 ;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  wire [2:0]\Dual.gpio2_OE_reg[0] ;
  wire \Dual.gpio_Data_In_reg[0] ;
  wire \Dual.gpio_OE[0]_i_2_n_0 ;
  wire \Dual.gpio_OE_reg[0] ;
  wire [0:0]E;
  wire \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ;
  wire \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ;
  wire [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 ;
  wire \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ;
  wire \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ;
  wire GPIO_xferAck_i;
  wire \MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0 ;
  wire \MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ;
  wire Q;
  wire ce_expnd_i_0;
  wire ce_expnd_i_1;
  wire ce_expnd_i_2;
  wire ce_expnd_i_3;
  wire cs_ce_clr;
  wire [0:0]gpio_Data_In;
  wire gpio_xferAck_Reg;
  wire \ip2bus_data_i_D1[31]_i_2_n_0 ;
  wire \ip2bus_data_i_D1[31]_i_3_n_0 ;
  wire ip2bus_rdack_i_D1;
  wire ip2bus_rdack_i_D1_reg;
  wire ip2bus_wrack_i_D1;
  wire ip2bus_wrack_i_D1_reg;
  wire s_axi_aclk;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire [3:0]s_axi_arready_0;
  wire s_axi_awready;
  wire [31:0]s_axi_wdata;
  wire s_axi_wdata_0_sn_1;

  assign s_axi_wdata_0_sp_1 = s_axi_wdata_0_sn_1;
  LUT3 #(
    .INIT(8'hB8)) 
    Bus_RNW_reg_i_1
       (.I0(Bus_RNW_reg_reg_0),
        .I1(Q),
        .I2(Bus_RNW_reg),
        .O(Bus_RNW_reg_i_1_n_0));
  FDRE Bus_RNW_reg_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(Bus_RNW_reg_i_1_n_0),
        .Q(Bus_RNW_reg),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h0000C808)) 
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_1 
       (.I0(gpio_Data_In),
        .I1(\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0 ),
        .I2(\Dual.gpio2_OE_reg[0] [0]),
        .I3(\Dual.gpio_OE_reg[0] ),
        .I4(\Dual.gpio2_OE_reg[0] [1]),
        .O(\Dual.gpio_Data_In_reg[0] ));
  LUT5 #(
    .INIT(32'h00000020)) 
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2 
       (.I0(Bus_RNW_reg_reg_0),
        .I1(gpio_xferAck_Reg),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I3(GPIO_xferAck_i),
        .I4(\Dual.gpio2_OE_reg[0] [2]),
        .O(\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00200000)) 
    \Dual.gpio2_OE[0]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [0]),
        .I1(Bus_RNW_reg_reg_0),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I3(\Dual.gpio2_OE_reg[0] [2]),
        .I4(\Dual.gpio2_OE_reg[0] [1]),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hEF40)) 
    \Dual.gpio2_OE[0]_i_2 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[0]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I3(s_axi_wdata[31]),
        .O(D[31]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[10]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[21]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[21]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[11]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[20]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[20]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[12]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[19]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[19]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[13]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[18]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[18]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[14]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[17]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[17]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[15]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[16]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[16]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[16]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[15]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[17]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[14]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[18]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[13]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[19]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[12]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[1]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[30]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[30]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[20]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[11]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[21]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[10]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[22]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[9]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[9]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[23]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[8]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[24]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[7]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[25]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[6]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[26]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[5]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[27]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[4]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[28]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[3]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[29]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[2]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[2]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[29]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[29]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[30]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[1]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[31]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[0]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[3]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[28]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[28]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[4]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[27]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[27]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[5]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[26]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[26]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[6]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[25]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[25]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[7]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[24]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[24]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[8]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[23]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[23]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h8C)) 
    \Dual.gpio2_OE[9]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [1]),
        .I1(s_axi_wdata[22]),
        .I2(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .O(D[22]));
  LUT6 #(
    .INIT(64'hFFFFB8FF0000B800)) 
    \Dual.gpio_OE[0]_i_1 
       (.I0(s_axi_wdata[0]),
        .I1(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I2(s_axi_wdata[31]),
        .I3(\Dual.gpio_OE[0]_i_2_n_0 ),
        .I4(\Dual.gpio2_OE_reg[0] [1]),
        .I5(\Dual.gpio_OE_reg[0] ),
        .O(s_axi_wdata_0_sn_1));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h0400)) 
    \Dual.gpio_OE[0]_i_2 
       (.I0(\Dual.gpio2_OE_reg[0] [2]),
        .I1(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I2(Bus_RNW_reg_reg_0),
        .I3(\Dual.gpio2_OE_reg[0] [0]),
        .O(\Dual.gpio_OE[0]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'h1)) 
    \GEN_BKEND_CE_REGISTERS[0].ce_out_i[0]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [0]),
        .I1(\Dual.gpio2_OE_reg[0] [1]),
        .O(ce_expnd_i_3));
  FDRE \GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(Q),
        .D(ce_expnd_i_3),
        .Q(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .R(cs_ce_clr));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i[1]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [0]),
        .I1(\Dual.gpio2_OE_reg[0] [1]),
        .O(ce_expnd_i_2));
  FDRE \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] 
       (.C(s_axi_aclk),
        .CE(Q),
        .D(ce_expnd_i_2),
        .Q(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .R(cs_ce_clr));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \GEN_BKEND_CE_REGISTERS[2].ce_out_i[2]_i_1 
       (.I0(\Dual.gpio2_OE_reg[0] [0]),
        .I1(\Dual.gpio2_OE_reg[0] [1]),
        .O(ce_expnd_i_1));
  FDRE \GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(Q),
        .D(ce_expnd_i_1),
        .Q(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .R(cs_ce_clr));
  LUT3 #(
    .INIT(8'hEF)) 
    \GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_1 
       (.I0(ip2bus_wrack_i_D1_reg),
        .I1(ip2bus_rdack_i_D1_reg),
        .I2(s_axi_aresetn),
        .O(cs_ce_clr));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \GEN_BKEND_CE_REGISTERS[3].ce_out_i[3]_i_2 
       (.I0(\Dual.gpio2_OE_reg[0] [0]),
        .I1(\Dual.gpio2_OE_reg[0] [1]),
        .O(ce_expnd_i_0));
  FDRE \GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(Q),
        .D(ce_expnd_i_0),
        .Q(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .R(cs_ce_clr));
  LUT5 #(
    .INIT(32'h000000E0)) 
    \MEM_DECODE_GEN[0].cs_out_i[0]_i_1 
       (.I0(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .I1(Q),
        .I2(s_axi_aresetn),
        .I3(ip2bus_rdack_i_D1_reg),
        .I4(ip2bus_wrack_i_D1_reg),
        .O(\MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0 ));
  FDRE \MEM_DECODE_GEN[0].cs_out_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\MEM_DECODE_GEN[0].cs_out_i[0]_i_1_n_0 ),
        .Q(\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[0]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [31]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[10]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [21]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[11]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [20]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[12]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [19]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[13]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [18]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[14]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [17]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[15]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [16]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[16]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [15]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[17]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [14]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[18]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [13]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[19]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [12]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[1]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [30]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[20]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [11]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[21]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [10]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[22]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [9]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[23]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [8]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[24]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [7]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[25]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [6]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[26]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [5]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[27]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [4]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[28]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [3]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[29]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [2]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[2]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [29]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[30]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [1]));
  LUT5 #(
    .INIT(32'h05004A00)) 
    \ip2bus_data_i_D1[31]_i_2 
       (.I0(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I1(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(Bus_RNW_reg),
        .I4(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .O(\ip2bus_data_i_D1[31]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00001000)) 
    \ip2bus_data_i_D1[31]_i_3 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I2(Bus_RNW_reg),
        .I3(\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .O(\ip2bus_data_i_D1[31]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[3]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [28]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[4]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [27]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[5]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [26]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[6]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [25]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[7]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [24]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[8]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [23]));
  LUT6 #(
    .INIT(64'h0000000004044808)) 
    \ip2bus_data_i_D1[9]_i_1 
       (.I0(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg ),
        .I1(Bus_RNW_reg),
        .I2(\GEN_BKEND_CE_REGISTERS[2].ce_out_i_reg ),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .I4(\GEN_BKEND_CE_REGISTERS[3].ce_out_i_reg ),
        .I5(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [22]));
  MUXF7 \ip2bus_data_i_D1_reg[31]_i_1 
       (.I0(\ip2bus_data_i_D1[31]_i_2_n_0 ),
        .I1(\ip2bus_data_i_D1[31]_i_3_n_0 ),
        .O(\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 [0]),
        .S(\GEN_BKEND_CE_REGISTERS[0].ce_out_i_reg ));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAEAAAA)) 
    s_axi_arready_INST_0
       (.I0(ip2bus_rdack_i_D1),
        .I1(s_axi_arready),
        .I2(s_axi_arready_0[2]),
        .I3(s_axi_arready_0[1]),
        .I4(s_axi_arready_0[3]),
        .I5(s_axi_arready_0[0]),
        .O(ip2bus_rdack_i_D1_reg));
  LUT6 #(
    .INIT(64'hAAAAAAAAAAAEAAAA)) 
    s_axi_wready_INST_0
       (.I0(ip2bus_wrack_i_D1),
        .I1(s_axi_awready),
        .I2(s_axi_arready_0[2]),
        .I3(s_axi_arready_0[1]),
        .I4(s_axi_arready_0[3]),
        .I5(s_axi_arready_0[0]),
        .O(ip2bus_wrack_i_D1_reg));
endmodule

(* C_ALL_INPUTS = "1" *) (* C_ALL_INPUTS_2 = "1" *) (* C_ALL_OUTPUTS = "0" *) 
(* C_ALL_OUTPUTS_2 = "0" *) (* C_DOUT_DEFAULT = "32'b00000000000000000000000000000000" *) (* C_DOUT_DEFAULT_2 = "32'b00000000000000000000000000000000" *) 
(* C_FAMILY = "zynq" *) (* C_GPIO2_WIDTH = "32" *) (* C_GPIO_WIDTH = "1" *) 
(* C_INTERRUPT_PRESENT = "0" *) (* C_IS_DUAL = "1" *) (* C_S_AXI_ADDR_WIDTH = "9" *) 
(* C_S_AXI_DATA_WIDTH = "32" *) (* C_TRI_DEFAULT = "32'b11111111111111111111111111111111" *) (* C_TRI_DEFAULT_2 = "32'b11111111111111111111111111111111" *) 
(* downgradeipidentifiedwarnings = "yes" *) (* ip_group = "LOGICORE" *) 
module c6v_return_state_gpio_0_axi_gpio
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
    ip2intc_irpt,
    gpio_io_i,
    gpio_io_o,
    gpio_io_t,
    gpio2_io_i,
    gpio2_io_o,
    gpio2_io_t);
  (* sigis = "Clk" *) input s_axi_aclk;
  (* sigis = "Rst" *) input s_axi_aresetn;
  input [8:0]s_axi_awaddr;
  input s_axi_awvalid;
  output s_axi_awready;
  input [31:0]s_axi_wdata;
  input [3:0]s_axi_wstrb;
  input s_axi_wvalid;
  output s_axi_wready;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [8:0]s_axi_araddr;
  input s_axi_arvalid;
  output s_axi_arready;
  output [31:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rvalid;
  input s_axi_rready;
  (* sigis = "INTR_LEVEL_HIGH" *) output ip2intc_irpt;
  input [0:0]gpio_io_i;
  output [0:0]gpio_io_o;
  output [0:0]gpio_io_t;
  input [31:0]gpio2_io_i;
  output [31:0]gpio2_io_o;
  output [31:0]gpio2_io_t;

  wire \<const0> ;
  wire AXI_LITE_IPIF_I_n_10;
  wire AXI_LITE_IPIF_I_n_11;
  wire AXI_LITE_IPIF_I_n_12;
  wire AXI_LITE_IPIF_I_n_13;
  wire AXI_LITE_IPIF_I_n_14;
  wire AXI_LITE_IPIF_I_n_15;
  wire AXI_LITE_IPIF_I_n_16;
  wire AXI_LITE_IPIF_I_n_17;
  wire AXI_LITE_IPIF_I_n_18;
  wire AXI_LITE_IPIF_I_n_19;
  wire AXI_LITE_IPIF_I_n_20;
  wire AXI_LITE_IPIF_I_n_21;
  wire AXI_LITE_IPIF_I_n_22;
  wire AXI_LITE_IPIF_I_n_23;
  wire AXI_LITE_IPIF_I_n_24;
  wire AXI_LITE_IPIF_I_n_25;
  wire AXI_LITE_IPIF_I_n_26;
  wire AXI_LITE_IPIF_I_n_27;
  wire AXI_LITE_IPIF_I_n_28;
  wire AXI_LITE_IPIF_I_n_29;
  wire AXI_LITE_IPIF_I_n_30;
  wire AXI_LITE_IPIF_I_n_31;
  wire AXI_LITE_IPIF_I_n_32;
  wire AXI_LITE_IPIF_I_n_33;
  wire AXI_LITE_IPIF_I_n_34;
  wire AXI_LITE_IPIF_I_n_35;
  wire AXI_LITE_IPIF_I_n_36;
  wire AXI_LITE_IPIF_I_n_37;
  wire AXI_LITE_IPIF_I_n_38;
  wire AXI_LITE_IPIF_I_n_5;
  wire AXI_LITE_IPIF_I_n_7;
  wire AXI_LITE_IPIF_I_n_73;
  wire AXI_LITE_IPIF_I_n_8;
  wire AXI_LITE_IPIF_I_n_9;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  wire [0:31]\Dual.Read_Reg2_In ;
  wire [0:31]\Dual.gpio2_Data_In ;
  wire GPIO_xferAck_i;
  wire [0:0]bus2ip_cs;
  wire bus2ip_reset;
  wire bus2ip_rnw;
  wire [31:0]gpio2_io_i;
  wire [0:0]gpio_Data_In;
  wire gpio_core_1_n_36;
  wire gpio_core_1_n_39;
  wire gpio_core_1_n_40;
  wire gpio_core_1_n_41;
  wire gpio_core_1_n_42;
  wire gpio_core_1_n_43;
  wire gpio_core_1_n_44;
  wire gpio_core_1_n_45;
  wire gpio_core_1_n_46;
  wire gpio_core_1_n_47;
  wire gpio_core_1_n_48;
  wire gpio_core_1_n_49;
  wire gpio_core_1_n_50;
  wire gpio_core_1_n_51;
  wire gpio_core_1_n_52;
  wire gpio_core_1_n_53;
  wire gpio_core_1_n_54;
  wire gpio_core_1_n_55;
  wire gpio_core_1_n_56;
  wire gpio_core_1_n_57;
  wire gpio_core_1_n_58;
  wire gpio_core_1_n_59;
  wire gpio_core_1_n_60;
  wire gpio_core_1_n_61;
  wire gpio_core_1_n_62;
  wire gpio_core_1_n_63;
  wire gpio_core_1_n_64;
  wire gpio_core_1_n_65;
  wire gpio_core_1_n_66;
  wire gpio_core_1_n_67;
  wire gpio_core_1_n_68;
  wire gpio_core_1_n_69;
  wire gpio_core_1_n_70;
  wire [0:0]gpio_io_i;
  wire gpio_xferAck_Reg;
  wire [0:31]ip2bus_data;
  wire [0:31]ip2bus_data_i_D1;
  wire ip2bus_rdack_i;
  wire ip2bus_rdack_i_D1;
  wire ip2bus_wrack_i;
  wire ip2bus_wrack_i_D1;
  wire p_0_in;
  wire s_axi_aclk;
  wire [8:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [8:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wvalid;

  assign gpio2_io_o[31] = \<const0> ;
  assign gpio2_io_o[30] = \<const0> ;
  assign gpio2_io_o[29] = \<const0> ;
  assign gpio2_io_o[28] = \<const0> ;
  assign gpio2_io_o[27] = \<const0> ;
  assign gpio2_io_o[26] = \<const0> ;
  assign gpio2_io_o[25] = \<const0> ;
  assign gpio2_io_o[24] = \<const0> ;
  assign gpio2_io_o[23] = \<const0> ;
  assign gpio2_io_o[22] = \<const0> ;
  assign gpio2_io_o[21] = \<const0> ;
  assign gpio2_io_o[20] = \<const0> ;
  assign gpio2_io_o[19] = \<const0> ;
  assign gpio2_io_o[18] = \<const0> ;
  assign gpio2_io_o[17] = \<const0> ;
  assign gpio2_io_o[16] = \<const0> ;
  assign gpio2_io_o[15] = \<const0> ;
  assign gpio2_io_o[14] = \<const0> ;
  assign gpio2_io_o[13] = \<const0> ;
  assign gpio2_io_o[12] = \<const0> ;
  assign gpio2_io_o[11] = \<const0> ;
  assign gpio2_io_o[10] = \<const0> ;
  assign gpio2_io_o[9] = \<const0> ;
  assign gpio2_io_o[8] = \<const0> ;
  assign gpio2_io_o[7] = \<const0> ;
  assign gpio2_io_o[6] = \<const0> ;
  assign gpio2_io_o[5] = \<const0> ;
  assign gpio2_io_o[4] = \<const0> ;
  assign gpio2_io_o[3] = \<const0> ;
  assign gpio2_io_o[2] = \<const0> ;
  assign gpio2_io_o[1] = \<const0> ;
  assign gpio2_io_o[0] = \<const0> ;
  assign gpio2_io_t[31] = \<const0> ;
  assign gpio2_io_t[30] = \<const0> ;
  assign gpio2_io_t[29] = \<const0> ;
  assign gpio2_io_t[28] = \<const0> ;
  assign gpio2_io_t[27] = \<const0> ;
  assign gpio2_io_t[26] = \<const0> ;
  assign gpio2_io_t[25] = \<const0> ;
  assign gpio2_io_t[24] = \<const0> ;
  assign gpio2_io_t[23] = \<const0> ;
  assign gpio2_io_t[22] = \<const0> ;
  assign gpio2_io_t[21] = \<const0> ;
  assign gpio2_io_t[20] = \<const0> ;
  assign gpio2_io_t[19] = \<const0> ;
  assign gpio2_io_t[18] = \<const0> ;
  assign gpio2_io_t[17] = \<const0> ;
  assign gpio2_io_t[16] = \<const0> ;
  assign gpio2_io_t[15] = \<const0> ;
  assign gpio2_io_t[14] = \<const0> ;
  assign gpio2_io_t[13] = \<const0> ;
  assign gpio2_io_t[12] = \<const0> ;
  assign gpio2_io_t[11] = \<const0> ;
  assign gpio2_io_t[10] = \<const0> ;
  assign gpio2_io_t[9] = \<const0> ;
  assign gpio2_io_t[8] = \<const0> ;
  assign gpio2_io_t[7] = \<const0> ;
  assign gpio2_io_t[6] = \<const0> ;
  assign gpio2_io_t[5] = \<const0> ;
  assign gpio2_io_t[4] = \<const0> ;
  assign gpio2_io_t[3] = \<const0> ;
  assign gpio2_io_t[2] = \<const0> ;
  assign gpio2_io_t[1] = \<const0> ;
  assign gpio2_io_t[0] = \<const0> ;
  assign gpio_io_o[0] = \<const0> ;
  assign gpio_io_t[0] = \<const0> ;
  assign ip2intc_irpt = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_wready = s_axi_awready;
  c6v_return_state_gpio_0_axi_lite_ipif AXI_LITE_IPIF_I
       (.D({p_0_in,AXI_LITE_IPIF_I_n_7,AXI_LITE_IPIF_I_n_8,AXI_LITE_IPIF_I_n_9,AXI_LITE_IPIF_I_n_10,AXI_LITE_IPIF_I_n_11,AXI_LITE_IPIF_I_n_12,AXI_LITE_IPIF_I_n_13,AXI_LITE_IPIF_I_n_14,AXI_LITE_IPIF_I_n_15,AXI_LITE_IPIF_I_n_16,AXI_LITE_IPIF_I_n_17,AXI_LITE_IPIF_I_n_18,AXI_LITE_IPIF_I_n_19,AXI_LITE_IPIF_I_n_20,AXI_LITE_IPIF_I_n_21,AXI_LITE_IPIF_I_n_22,AXI_LITE_IPIF_I_n_23,AXI_LITE_IPIF_I_n_24,AXI_LITE_IPIF_I_n_25,AXI_LITE_IPIF_I_n_26,AXI_LITE_IPIF_I_n_27,AXI_LITE_IPIF_I_n_28,AXI_LITE_IPIF_I_n_29,AXI_LITE_IPIF_I_n_30,AXI_LITE_IPIF_I_n_31,AXI_LITE_IPIF_I_n_32,AXI_LITE_IPIF_I_n_33,AXI_LITE_IPIF_I_n_34,AXI_LITE_IPIF_I_n_35,AXI_LITE_IPIF_I_n_36,AXI_LITE_IPIF_I_n_37}),
        .\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg (\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ({gpio_core_1_n_39,gpio_core_1_n_40,gpio_core_1_n_41,gpio_core_1_n_42,gpio_core_1_n_43,gpio_core_1_n_44,gpio_core_1_n_45,gpio_core_1_n_46,gpio_core_1_n_47,gpio_core_1_n_48,gpio_core_1_n_49,gpio_core_1_n_50,gpio_core_1_n_51,gpio_core_1_n_52,gpio_core_1_n_53,gpio_core_1_n_54,gpio_core_1_n_55,gpio_core_1_n_56,gpio_core_1_n_57,gpio_core_1_n_58,gpio_core_1_n_59,gpio_core_1_n_60,gpio_core_1_n_61,gpio_core_1_n_62,gpio_core_1_n_63,gpio_core_1_n_64,gpio_core_1_n_65,gpio_core_1_n_66,gpio_core_1_n_67,gpio_core_1_n_68,gpio_core_1_n_69,gpio_core_1_n_70}),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .\Dual.Read_Reg2_In (\Dual.Read_Reg2_In ),
        .\Dual.gpio_Data_In_reg[0] (AXI_LITE_IPIF_I_n_5),
        .\Dual.gpio_OE_reg[0] (gpio_core_1_n_36),
        .E(AXI_LITE_IPIF_I_n_38),
        .\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ({ip2bus_data[0],ip2bus_data[1],ip2bus_data[2],ip2bus_data[3],ip2bus_data[4],ip2bus_data[5],ip2bus_data[6],ip2bus_data[7],ip2bus_data[8],ip2bus_data[9],ip2bus_data[10],ip2bus_data[11],ip2bus_data[12],ip2bus_data[13],ip2bus_data[14],ip2bus_data[15],ip2bus_data[16],ip2bus_data[17],ip2bus_data[18],ip2bus_data[19],ip2bus_data[20],ip2bus_data[21],ip2bus_data[22],ip2bus_data[23],ip2bus_data[24],ip2bus_data[25],ip2bus_data[26],ip2bus_data[27],ip2bus_data[28],ip2bus_data[29],ip2bus_data[30],ip2bus_data[31]}),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .Q({\Dual.gpio2_Data_In [0],\Dual.gpio2_Data_In [1],\Dual.gpio2_Data_In [2],\Dual.gpio2_Data_In [3],\Dual.gpio2_Data_In [4],\Dual.gpio2_Data_In [5],\Dual.gpio2_Data_In [6],\Dual.gpio2_Data_In [7],\Dual.gpio2_Data_In [8],\Dual.gpio2_Data_In [9],\Dual.gpio2_Data_In [10],\Dual.gpio2_Data_In [11],\Dual.gpio2_Data_In [12],\Dual.gpio2_Data_In [13],\Dual.gpio2_Data_In [14],\Dual.gpio2_Data_In [15],\Dual.gpio2_Data_In [16],\Dual.gpio2_Data_In [17],\Dual.gpio2_Data_In [18],\Dual.gpio2_Data_In [19],\Dual.gpio2_Data_In [20],\Dual.gpio2_Data_In [21],\Dual.gpio2_Data_In [22],\Dual.gpio2_Data_In [23],\Dual.gpio2_Data_In [24],\Dual.gpio2_Data_In [25],\Dual.gpio2_Data_In [26],\Dual.gpio2_Data_In [27],\Dual.gpio2_Data_In [28],\Dual.gpio2_Data_In [29],\Dual.gpio2_Data_In [30],\Dual.gpio2_Data_In [31]}),
        .bus2ip_cs(bus2ip_cs),
        .bus2ip_reset(bus2ip_reset),
        .bus2ip_rnw(bus2ip_rnw),
        .gpio_Data_In(gpio_Data_In),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
        .ip2bus_rdack_i_D1(ip2bus_rdack_i_D1),
        .ip2bus_rdack_i_D1_reg(s_axi_arready),
        .ip2bus_wrack_i_D1(ip2bus_wrack_i_D1),
        .ip2bus_wrack_i_D1_reg(s_axi_awready),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr({s_axi_araddr[8],s_axi_araddr[3:2]}),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr({s_axi_awaddr[8],s_axi_awaddr[3:2]}),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid_i_reg(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .\s_axi_rdata_i_reg[31] ({ip2bus_data_i_D1[0],ip2bus_data_i_D1[1],ip2bus_data_i_D1[2],ip2bus_data_i_D1[3],ip2bus_data_i_D1[4],ip2bus_data_i_D1[5],ip2bus_data_i_D1[6],ip2bus_data_i_D1[7],ip2bus_data_i_D1[8],ip2bus_data_i_D1[9],ip2bus_data_i_D1[10],ip2bus_data_i_D1[11],ip2bus_data_i_D1[12],ip2bus_data_i_D1[13],ip2bus_data_i_D1[14],ip2bus_data_i_D1[15],ip2bus_data_i_D1[16],ip2bus_data_i_D1[17],ip2bus_data_i_D1[18],ip2bus_data_i_D1[19],ip2bus_data_i_D1[20],ip2bus_data_i_D1[21],ip2bus_data_i_D1[22],ip2bus_data_i_D1[23],ip2bus_data_i_D1[24],ip2bus_data_i_D1[25],ip2bus_data_i_D1[26],ip2bus_data_i_D1[27],ip2bus_data_i_D1[28],ip2bus_data_i_D1[29],ip2bus_data_i_D1[30],ip2bus_data_i_D1[31]}),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid_i_reg(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wdata_0_sp_1(AXI_LITE_IPIF_I_n_73),
        .s_axi_wvalid(s_axi_wvalid));
  GND GND
       (.G(\<const0> ));
  c6v_return_state_gpio_0_GPIO_Core gpio_core_1
       (.D({p_0_in,AXI_LITE_IPIF_I_n_7,AXI_LITE_IPIF_I_n_8,AXI_LITE_IPIF_I_n_9,AXI_LITE_IPIF_I_n_10,AXI_LITE_IPIF_I_n_11,AXI_LITE_IPIF_I_n_12,AXI_LITE_IPIF_I_n_13,AXI_LITE_IPIF_I_n_14,AXI_LITE_IPIF_I_n_15,AXI_LITE_IPIF_I_n_16,AXI_LITE_IPIF_I_n_17,AXI_LITE_IPIF_I_n_18,AXI_LITE_IPIF_I_n_19,AXI_LITE_IPIF_I_n_20,AXI_LITE_IPIF_I_n_21,AXI_LITE_IPIF_I_n_22,AXI_LITE_IPIF_I_n_23,AXI_LITE_IPIF_I_n_24,AXI_LITE_IPIF_I_n_25,AXI_LITE_IPIF_I_n_26,AXI_LITE_IPIF_I_n_27,AXI_LITE_IPIF_I_n_28,AXI_LITE_IPIF_I_n_29,AXI_LITE_IPIF_I_n_30,AXI_LITE_IPIF_I_n_31,AXI_LITE_IPIF_I_n_32,AXI_LITE_IPIF_I_n_33,AXI_LITE_IPIF_I_n_34,AXI_LITE_IPIF_I_n_35,AXI_LITE_IPIF_I_n_36,AXI_LITE_IPIF_I_n_37}),
        .\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg (\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg[31]_0 (AXI_LITE_IPIF_I_n_5),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .\Dual.Read_Reg2_In (\Dual.Read_Reg2_In ),
        .\Dual.gpio2_Data_In_reg[0]_0 ({\Dual.gpio2_Data_In [0],\Dual.gpio2_Data_In [1],\Dual.gpio2_Data_In [2],\Dual.gpio2_Data_In [3],\Dual.gpio2_Data_In [4],\Dual.gpio2_Data_In [5],\Dual.gpio2_Data_In [6],\Dual.gpio2_Data_In [7],\Dual.gpio2_Data_In [8],\Dual.gpio2_Data_In [9],\Dual.gpio2_Data_In [10],\Dual.gpio2_Data_In [11],\Dual.gpio2_Data_In [12],\Dual.gpio2_Data_In [13],\Dual.gpio2_Data_In [14],\Dual.gpio2_Data_In [15],\Dual.gpio2_Data_In [16],\Dual.gpio2_Data_In [17],\Dual.gpio2_Data_In [18],\Dual.gpio2_Data_In [19],\Dual.gpio2_Data_In [20],\Dual.gpio2_Data_In [21],\Dual.gpio2_Data_In [22],\Dual.gpio2_Data_In [23],\Dual.gpio2_Data_In [24],\Dual.gpio2_Data_In [25],\Dual.gpio2_Data_In [26],\Dual.gpio2_Data_In [27],\Dual.gpio2_Data_In [28],\Dual.gpio2_Data_In [29],\Dual.gpio2_Data_In [30],\Dual.gpio2_Data_In [31]}),
        .\Dual.gpio_OE_reg[0]_0 (gpio_core_1_n_36),
        .\Dual.gpio_OE_reg[0]_1 (AXI_LITE_IPIF_I_n_73),
        .E(AXI_LITE_IPIF_I_n_38),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .Q({gpio_core_1_n_39,gpio_core_1_n_40,gpio_core_1_n_41,gpio_core_1_n_42,gpio_core_1_n_43,gpio_core_1_n_44,gpio_core_1_n_45,gpio_core_1_n_46,gpio_core_1_n_47,gpio_core_1_n_48,gpio_core_1_n_49,gpio_core_1_n_50,gpio_core_1_n_51,gpio_core_1_n_52,gpio_core_1_n_53,gpio_core_1_n_54,gpio_core_1_n_55,gpio_core_1_n_56,gpio_core_1_n_57,gpio_core_1_n_58,gpio_core_1_n_59,gpio_core_1_n_60,gpio_core_1_n_61,gpio_core_1_n_62,gpio_core_1_n_63,gpio_core_1_n_64,gpio_core_1_n_65,gpio_core_1_n_66,gpio_core_1_n_67,gpio_core_1_n_68,gpio_core_1_n_69,gpio_core_1_n_70}),
        .bus2ip_cs(bus2ip_cs),
        .bus2ip_reset(bus2ip_reset),
        .bus2ip_rnw(bus2ip_rnw),
        .gpio2_io_i(gpio2_io_i),
        .gpio_Data_In(gpio_Data_In),
        .gpio_io_i(gpio_io_i),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
        .ip2bus_rdack_i(ip2bus_rdack_i),
        .ip2bus_wrack_i(ip2bus_wrack_i),
        .s_axi_aclk(s_axi_aclk));
  FDRE \ip2bus_data_i_D1_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[0]),
        .Q(ip2bus_data_i_D1[0]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[10]),
        .Q(ip2bus_data_i_D1[10]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[11] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[11]),
        .Q(ip2bus_data_i_D1[11]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[12]),
        .Q(ip2bus_data_i_D1[12]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[13]),
        .Q(ip2bus_data_i_D1[13]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[14] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[14]),
        .Q(ip2bus_data_i_D1[14]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[15] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[15]),
        .Q(ip2bus_data_i_D1[15]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[16] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[16]),
        .Q(ip2bus_data_i_D1[16]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[17] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[17]),
        .Q(ip2bus_data_i_D1[17]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[18] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[18]),
        .Q(ip2bus_data_i_D1[18]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[19] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[19]),
        .Q(ip2bus_data_i_D1[19]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[1]),
        .Q(ip2bus_data_i_D1[1]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[20] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[20]),
        .Q(ip2bus_data_i_D1[20]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[21] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[21]),
        .Q(ip2bus_data_i_D1[21]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[22] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[22]),
        .Q(ip2bus_data_i_D1[22]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[23] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[23]),
        .Q(ip2bus_data_i_D1[23]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[24] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[24]),
        .Q(ip2bus_data_i_D1[24]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[25] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[25]),
        .Q(ip2bus_data_i_D1[25]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[26] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[26]),
        .Q(ip2bus_data_i_D1[26]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[27] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[27]),
        .Q(ip2bus_data_i_D1[27]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[28] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[28]),
        .Q(ip2bus_data_i_D1[28]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[29] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[29]),
        .Q(ip2bus_data_i_D1[29]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[2]),
        .Q(ip2bus_data_i_D1[2]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[30] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[30]),
        .Q(ip2bus_data_i_D1[30]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[31] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[31]),
        .Q(ip2bus_data_i_D1[31]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[3]),
        .Q(ip2bus_data_i_D1[3]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[4]),
        .Q(ip2bus_data_i_D1[4]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[5]),
        .Q(ip2bus_data_i_D1[5]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[6]),
        .Q(ip2bus_data_i_D1[6]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[7]),
        .Q(ip2bus_data_i_D1[7]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[8]),
        .Q(ip2bus_data_i_D1[8]),
        .R(bus2ip_reset));
  FDRE \ip2bus_data_i_D1_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_data[9]),
        .Q(ip2bus_data_i_D1[9]),
        .R(bus2ip_reset));
  FDRE ip2bus_rdack_i_D1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_rdack_i),
        .Q(ip2bus_rdack_i_D1),
        .R(bus2ip_reset));
  FDRE ip2bus_wrack_i_D1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(ip2bus_wrack_i),
        .Q(ip2bus_wrack_i_D1),
        .R(bus2ip_reset));
endmodule

module c6v_return_state_gpio_0_axi_lite_ipif
   (bus2ip_reset,
    bus2ip_rnw,
    s_axi_rvalid_i_reg,
    s_axi_bvalid_i_reg,
    bus2ip_cs,
    \Dual.gpio_Data_In_reg[0] ,
    D,
    E,
    \Dual.Read_Reg2_In ,
    ip2bus_rdack_i_D1_reg,
    ip2bus_wrack_i_D1_reg,
    s_axi_wdata_0_sp_1,
    s_axi_rdata,
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ,
    s_axi_aclk,
    s_axi_arvalid,
    gpio_Data_In,
    \Dual.gpio_OE_reg[0] ,
    gpio_xferAck_Reg,
    GPIO_xferAck_i,
    s_axi_wdata,
    Q,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ,
    s_axi_rready,
    s_axi_bready,
    s_axi_aresetn,
    s_axi_awvalid,
    s_axi_wvalid,
    \s_axi_rdata_i_reg[31] ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ,
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ,
    ip2bus_rdack_i_D1,
    ip2bus_wrack_i_D1,
    s_axi_araddr,
    s_axi_awaddr);
  output bus2ip_reset;
  output bus2ip_rnw;
  output s_axi_rvalid_i_reg;
  output s_axi_bvalid_i_reg;
  output [0:0]bus2ip_cs;
  output \Dual.gpio_Data_In_reg[0] ;
  output [31:0]D;
  output [0:0]E;
  output [0:31]\Dual.Read_Reg2_In ;
  output ip2bus_rdack_i_D1_reg;
  output ip2bus_wrack_i_D1_reg;
  output s_axi_wdata_0_sp_1;
  output [31:0]s_axi_rdata;
  output [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ;
  input s_axi_aclk;
  input s_axi_arvalid;
  input [0:0]gpio_Data_In;
  input \Dual.gpio_OE_reg[0] ;
  input gpio_xferAck_Reg;
  input GPIO_xferAck_i;
  input [31:0]s_axi_wdata;
  input [31:0]Q;
  input [31:0]\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ;
  input s_axi_rready;
  input s_axi_bready;
  input s_axi_aresetn;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input [31:0]\s_axi_rdata_i_reg[31] ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  input \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  input ip2bus_rdack_i_D1;
  input ip2bus_wrack_i_D1;
  input [2:0]s_axi_araddr;
  input [2:0]s_axi_awaddr;

  wire [31:0]D;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  wire [31:0]\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  wire [0:31]\Dual.Read_Reg2_In ;
  wire \Dual.gpio_Data_In_reg[0] ;
  wire \Dual.gpio_OE_reg[0] ;
  wire [0:0]E;
  wire [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ;
  wire GPIO_xferAck_i;
  wire [31:0]Q;
  wire [0:0]bus2ip_cs;
  wire bus2ip_reset;
  wire bus2ip_rnw;
  wire [0:0]gpio_Data_In;
  wire gpio_xferAck_Reg;
  wire ip2bus_rdack_i_D1;
  wire ip2bus_rdack_i_D1_reg;
  wire ip2bus_wrack_i_D1;
  wire ip2bus_wrack_i_D1_reg;
  wire s_axi_aclk;
  wire [2:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arvalid;
  wire [2:0]s_axi_awaddr;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid_i_reg;
  wire [31:0]s_axi_rdata;
  wire [31:0]\s_axi_rdata_i_reg[31] ;
  wire s_axi_rready;
  wire s_axi_rvalid_i_reg;
  wire [31:0]s_axi_wdata;
  wire s_axi_wdata_0_sn_1;
  wire s_axi_wvalid;

  assign s_axi_wdata_0_sp_1 = s_axi_wdata_0_sn_1;
  c6v_return_state_gpio_0_slave_attachment I_SLAVE_ATTACHMENT
       (.D(D),
        .\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg (\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .\Dual.Read_Reg2_In (\Dual.Read_Reg2_In ),
        .\Dual.gpio_Data_In_reg[0] (\Dual.gpio_Data_In_reg[0] ),
        .\Dual.gpio_OE_reg[0] (\Dual.gpio_OE_reg[0] ),
        .E(E),
        .\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] (\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .\MEM_DECODE_GEN[0].cs_out_i_reg[0] (bus2ip_cs),
        .Q(Q),
        .SR(bus2ip_reset),
        .bus2ip_rnw_i_reg_0(bus2ip_rnw),
        .gpio_Data_In(gpio_Data_In),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
        .ip2bus_rdack_i_D1(ip2bus_rdack_i_D1),
        .ip2bus_rdack_i_D1_reg(ip2bus_rdack_i_D1_reg),
        .ip2bus_wrack_i_D1(ip2bus_wrack_i_D1),
        .ip2bus_wrack_i_D1_reg(ip2bus_wrack_i_D1_reg),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid_i_reg_0(s_axi_bvalid_i_reg),
        .s_axi_rdata(s_axi_rdata),
        .\s_axi_rdata_i_reg[31]_0 (\s_axi_rdata_i_reg[31] ),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid_i_reg_0(s_axi_rvalid_i_reg),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wdata_0_sp_1(s_axi_wdata_0_sn_1),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* CHECK_LICENSE_TYPE = "c6v_return_state_gpio_0,axi_gpio,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "axi_gpio,Vivado 2026.1" *) 
(* NotValidForBitStream *)
module c6v_return_state_gpio_0
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
    gpio_io_i,
    gpio2_io_i);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 S_AXI_ACLK CLK" *) (* x_interface_mode = "slave S_AXI_ACLK" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXI_ACLK, ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s_axi_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 S_AXI_ARESETN RST" *) (* x_interface_mode = "slave S_AXI_ARESETN" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXI_ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) (* x_interface_mode = "slave S_AXI" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXI, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 9, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN c6v_ps7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [8:0]s_axi_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [31:0]s_axi_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [3:0]s_axi_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [8:0]s_axi_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [31:0]s_axi_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* x_interface_info = "xilinx.com:interface:gpio:1.0 GPIO TRI_I" *) (* x_interface_mode = "master GPIO" *) (* x_interface_parameter = "XIL_INTERFACENAME GPIO, BOARD.ASSOCIATED_PARAM GPIO_BOARD_INTERFACE" *) input [0:0]gpio_io_i;
  (* x_interface_info = "xilinx.com:interface:gpio:1.0 GPIO2 TRI_I" *) (* x_interface_mode = "master GPIO2" *) (* x_interface_parameter = "XIL_INTERFACENAME GPIO2, BOARD.ASSOCIATED_PARAM GPIO2_BOARD_INTERFACE" *) input [31:0]gpio2_io_i;

  wire \<const0> ;
  wire [31:0]gpio2_io_i;
  wire [0:0]gpio_io_i;
  wire s_axi_aclk;
  wire [8:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [8:0]s_axi_awaddr;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [31:0]s_axi_rdata;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [31:0]s_axi_wdata;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire NLW_U0_ip2intc_irpt_UNCONNECTED;
  wire [31:0]NLW_U0_gpio2_io_o_UNCONNECTED;
  wire [31:0]NLW_U0_gpio2_io_t_UNCONNECTED;
  wire [0:0]NLW_U0_gpio_io_o_UNCONNECTED;
  wire [0:0]NLW_U0_gpio_io_t_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_ALL_INPUTS = "1" *) 
  (* C_ALL_INPUTS_2 = "1" *) 
  (* C_ALL_OUTPUTS = "0" *) 
  (* C_ALL_OUTPUTS_2 = "0" *) 
  (* C_DOUT_DEFAULT = "32'b00000000000000000000000000000000" *) 
  (* C_DOUT_DEFAULT_2 = "32'b00000000000000000000000000000000" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_GPIO2_WIDTH = "32" *) 
  (* C_GPIO_WIDTH = "1" *) 
  (* C_INTERRUPT_PRESENT = "0" *) 
  (* C_IS_DUAL = "1" *) 
  (* C_S_AXI_ADDR_WIDTH = "9" *) 
  (* C_S_AXI_DATA_WIDTH = "32" *) 
  (* C_TRI_DEFAULT = "32'b11111111111111111111111111111111" *) 
  (* C_TRI_DEFAULT_2 = "32'b11111111111111111111111111111111" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* ip_group = "LOGICORE" *) 
  c6v_return_state_gpio_0_axi_gpio U0
       (.gpio2_io_i(gpio2_io_i),
        .gpio2_io_o(NLW_U0_gpio2_io_o_UNCONNECTED[31:0]),
        .gpio2_io_t(NLW_U0_gpio2_io_t_UNCONNECTED[31:0]),
        .gpio_io_i(gpio_io_i),
        .gpio_io_o(NLW_U0_gpio_io_o_UNCONNECTED[0]),
        .gpio_io_t(NLW_U0_gpio_io_t_UNCONNECTED[0]),
        .ip2intc_irpt(NLW_U0_ip2intc_irpt_UNCONNECTED),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr({s_axi_araddr[8],1'b0,1'b0,1'b0,1'b0,s_axi_araddr[3:2],1'b0,1'b0}),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr({s_axi_awaddr[8],1'b0,1'b0,1'b0,1'b0,s_axi_awaddr[3:2],1'b0,1'b0}),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

module c6v_return_state_gpio_0_slave_attachment
   (SR,
    bus2ip_rnw_i_reg_0,
    s_axi_rvalid_i_reg_0,
    s_axi_bvalid_i_reg_0,
    \MEM_DECODE_GEN[0].cs_out_i_reg[0] ,
    \Dual.gpio_Data_In_reg[0] ,
    D,
    E,
    \Dual.Read_Reg2_In ,
    ip2bus_rdack_i_D1_reg,
    ip2bus_wrack_i_D1_reg,
    s_axi_wdata_0_sp_1,
    s_axi_rdata,
    \GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ,
    s_axi_aclk,
    s_axi_arvalid,
    gpio_Data_In,
    \Dual.gpio_OE_reg[0] ,
    gpio_xferAck_Reg,
    GPIO_xferAck_i,
    s_axi_wdata,
    Q,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ,
    s_axi_rready,
    s_axi_bready,
    s_axi_aresetn,
    s_axi_awvalid,
    s_axi_wvalid,
    \s_axi_rdata_i_reg[31]_0 ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ,
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ,
    \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ,
    ip2bus_rdack_i_D1,
    ip2bus_wrack_i_D1,
    s_axi_araddr,
    s_axi_awaddr);
  output [0:0]SR;
  output bus2ip_rnw_i_reg_0;
  output s_axi_rvalid_i_reg_0;
  output s_axi_bvalid_i_reg_0;
  output \MEM_DECODE_GEN[0].cs_out_i_reg[0] ;
  output \Dual.gpio_Data_In_reg[0] ;
  output [31:0]D;
  output [0:0]E;
  output [0:31]\Dual.Read_Reg2_In ;
  output ip2bus_rdack_i_D1_reg;
  output ip2bus_wrack_i_D1_reg;
  output s_axi_wdata_0_sp_1;
  output [31:0]s_axi_rdata;
  output [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ;
  input s_axi_aclk;
  input s_axi_arvalid;
  input [0:0]gpio_Data_In;
  input \Dual.gpio_OE_reg[0] ;
  input gpio_xferAck_Reg;
  input GPIO_xferAck_i;
  input [31:0]s_axi_wdata;
  input [31:0]Q;
  input [31:0]\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ;
  input s_axi_rready;
  input s_axi_bready;
  input s_axi_aresetn;
  input s_axi_awvalid;
  input s_axi_wvalid;
  input [31:0]\s_axi_rdata_i_reg[31]_0 ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  input \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  input \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  input ip2bus_rdack_i_D1;
  input ip2bus_wrack_i_D1;
  input [2:0]s_axi_araddr;
  input [2:0]s_axi_awaddr;

  wire [31:0]D;
  wire \Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ;
  wire [31:0]\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ;
  wire \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ;
  wire [0:31]\Dual.Read_Reg2_In ;
  wire \Dual.gpio_Data_In_reg[0] ;
  wire \Dual.gpio_OE_reg[0] ;
  wire [0:0]E;
  wire \FSM_onehot_state[0]_i_1_n_0 ;
  wire \FSM_onehot_state[1]_i_1_n_0 ;
  wire \FSM_onehot_state[2]_i_1_n_0 ;
  wire \FSM_onehot_state[3]_i_1_n_0 ;
  wire \FSM_onehot_state_reg_n_0_[0] ;
  wire \FSM_onehot_state_reg_n_0_[3] ;
  wire [31:0]\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ;
  wire GPIO_xferAck_i;
  wire [3:0]\INCLUDE_DPHASE_TIMER.dpto_cnt_reg ;
  wire \MEM_DECODE_GEN[0].cs_out_i_reg[0] ;
  wire [31:0]Q;
  wire [0:0]SR;
  wire [0:6]bus2ip_addr;
  wire \bus2ip_addr_i[8]_i_1_n_0 ;
  wire bus2ip_rnw_i_reg_0;
  wire clear;
  wire [0:0]gpio_Data_In;
  wire gpio_xferAck_Reg;
  wire ip2bus_rdack_i_D1;
  wire ip2bus_rdack_i_D1_reg;
  wire ip2bus_wrack_i_D1;
  wire ip2bus_wrack_i_D1_reg;
  wire is_read_i_1_n_0;
  wire is_read_reg_n_0;
  wire is_write_i_1_n_0;
  wire is_write_i_2_n_0;
  wire is_write_reg_n_0;
  wire [8:2]p_1_in;
  wire p_5_in;
  wire [3:0]plusOp;
  wire rst_i_1_n_0;
  wire s_axi_aclk;
  wire [2:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire s_axi_arvalid;
  wire [2:0]s_axi_awaddr;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire [0:0]s_axi_bresp_i;
  wire s_axi_bvalid_i_i_1_n_0;
  wire s_axi_bvalid_i_reg_0;
  wire [31:0]s_axi_rdata;
  wire [31:0]\s_axi_rdata_i_reg[31]_0 ;
  wire s_axi_rready;
  wire [0:0]s_axi_rresp_i;
  wire s_axi_rvalid_i_i_1_n_0;
  wire s_axi_rvalid_i_reg_0;
  wire [31:0]s_axi_wdata;
  wire s_axi_wdata_0_sn_1;
  wire s_axi_wvalid;
  wire start2;
  wire start2_i_1_n_0;
  wire state1__2;
  wire \state[0]_i_1_n_0 ;
  wire \state[1]_i_1_n_0 ;
  wire \state_reg_n_0_[0] ;
  wire \state_reg_n_0_[1] ;

  assign s_axi_wdata_0_sp_1 = s_axi_wdata_0_sn_1;
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3[0]_i_1 
       (.I0(Q[31]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [31]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [0]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3[10]_i_1 
       (.I0(Q[21]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [21]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [10]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3[11]_i_1 
       (.I0(Q[20]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [20]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [11]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3[12]_i_1 
       (.I0(Q[19]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [19]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [12]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3[13]_i_1 
       (.I0(Q[18]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [18]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [13]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3[14]_i_1 
       (.I0(Q[17]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [17]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [14]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3[15]_i_1 
       (.I0(Q[16]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [16]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [15]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3[16]_i_1 
       (.I0(Q[15]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [15]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [16]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3[17]_i_1 
       (.I0(Q[14]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [14]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [17]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3[18]_i_1 
       (.I0(Q[13]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [13]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [18]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3[19]_i_1 
       (.I0(Q[12]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [12]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [19]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3[1]_i_1 
       (.I0(Q[30]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [30]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [1]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3[20]_i_1 
       (.I0(Q[11]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [11]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [20]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3[21]_i_1 
       (.I0(Q[10]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [10]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [21]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3[22]_i_1 
       (.I0(Q[9]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [9]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [22]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3[23]_i_1 
       (.I0(Q[8]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [8]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [23]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3[24]_i_1 
       (.I0(Q[7]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [7]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [24]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3[25]_i_1 
       (.I0(Q[6]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [6]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [25]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3[26]_i_1 
       (.I0(Q[5]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [5]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [26]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3[27]_i_1 
       (.I0(Q[4]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [4]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [27]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3[28]_i_1 
       (.I0(Q[3]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [3]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [28]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3[29]_i_1 
       (.I0(Q[2]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [2]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [29]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3[2]_i_1 
       (.I0(Q[29]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [29]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [2]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3[30]_i_1 
       (.I0(Q[1]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [1]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [30]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3[31]_i_2 
       (.I0(Q[0]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [0]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [31]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3[3]_i_1 
       (.I0(Q[28]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [28]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [3]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3[4]_i_1 
       (.I0(Q[27]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [27]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [4]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3[5]_i_1 
       (.I0(Q[26]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [26]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [5]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3[6]_i_1 
       (.I0(Q[25]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [25]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [6]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3[7]_i_1 
       (.I0(Q[24]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [24]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [7]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3[8]_i_1 
       (.I0(Q[23]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [23]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [8]));
  LUT5 #(
    .INIT(32'h0E020000)) 
    \Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3[9]_i_1 
       (.I0(Q[22]),
        .I1(bus2ip_addr[6]),
        .I2(bus2ip_addr[0]),
        .I3(\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg[0] [22]),
        .I4(bus2ip_addr[5]),
        .O(\Dual.Read_Reg2_In [9]));
  LUT6 #(
    .INIT(64'hFFFF150015001500)) 
    \FSM_onehot_state[0]_i_1 
       (.I0(s_axi_arvalid),
        .I1(s_axi_wvalid),
        .I2(s_axi_awvalid),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(state1__2),
        .I5(\FSM_onehot_state_reg_n_0_[3] ),
        .O(\FSM_onehot_state[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8F88)) 
    \FSM_onehot_state[1]_i_1 
       (.I0(s_axi_arvalid),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(ip2bus_rdack_i_D1_reg),
        .I3(s_axi_rresp_i),
        .O(\FSM_onehot_state[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0800FFFF08000800)) 
    \FSM_onehot_state[2]_i_1 
       (.I0(s_axi_wvalid),
        .I1(s_axi_awvalid),
        .I2(s_axi_arvalid),
        .I3(\FSM_onehot_state_reg_n_0_[0] ),
        .I4(ip2bus_wrack_i_D1_reg),
        .I5(s_axi_bresp_i),
        .O(\FSM_onehot_state[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF888F888FFFFF888)) 
    \FSM_onehot_state[3]_i_1 
       (.I0(ip2bus_wrack_i_D1_reg),
        .I1(s_axi_bresp_i),
        .I2(s_axi_rresp_i),
        .I3(ip2bus_rdack_i_D1_reg),
        .I4(\FSM_onehot_state_reg_n_0_[3] ),
        .I5(state1__2),
        .O(\FSM_onehot_state[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hF888)) 
    \FSM_onehot_state[3]_i_2 
       (.I0(s_axi_bready),
        .I1(s_axi_bvalid_i_reg_0),
        .I2(s_axi_rready),
        .I3(s_axi_rvalid_i_reg_0),
        .O(state1__2));
  (* FSM_ENCODED_STATES = "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001" *) 
  FDSE #(
    .INIT(1'b1)) 
    \FSM_onehot_state_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[0]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[0] ),
        .S(SR));
  (* FSM_ENCODED_STATES = "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[1]_i_1_n_0 ),
        .Q(s_axi_rresp_i),
        .R(SR));
  (* FSM_ENCODED_STATES = "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[2]_i_1_n_0 ),
        .Q(s_axi_bresp_i),
        .R(SR));
  (* FSM_ENCODED_STATES = "iSTATE:0010,iSTATE0:0100,iSTATE1:1000,iSTATE2:0001" *) 
  FDRE #(
    .INIT(1'b0)) 
    \FSM_onehot_state_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_onehot_state[3]_i_1_n_0 ),
        .Q(\FSM_onehot_state_reg_n_0_[3] ),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \INCLUDE_DPHASE_TIMER.dpto_cnt[0]_i_1 
       (.I0(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [0]),
        .O(plusOp[0]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \INCLUDE_DPHASE_TIMER.dpto_cnt[1]_i_1 
       (.I0(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [0]),
        .I1(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [1]),
        .O(plusOp[1]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \INCLUDE_DPHASE_TIMER.dpto_cnt[2]_i_1 
       (.I0(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [0]),
        .I1(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [1]),
        .I2(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [2]),
        .O(plusOp[2]));
  LUT2 #(
    .INIT(4'h9)) 
    \INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_1 
       (.I0(\state_reg_n_0_[0] ),
        .I1(\state_reg_n_0_[1] ),
        .O(clear));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \INCLUDE_DPHASE_TIMER.dpto_cnt[3]_i_2 
       (.I0(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [1]),
        .I1(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [0]),
        .I2(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [2]),
        .I3(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [3]),
        .O(plusOp[3]));
  FDRE \INCLUDE_DPHASE_TIMER.dpto_cnt_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(plusOp[0]),
        .Q(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [0]),
        .R(clear));
  FDRE \INCLUDE_DPHASE_TIMER.dpto_cnt_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(plusOp[1]),
        .Q(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [1]),
        .R(clear));
  FDRE \INCLUDE_DPHASE_TIMER.dpto_cnt_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(plusOp[2]),
        .Q(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [2]),
        .R(clear));
  FDRE \INCLUDE_DPHASE_TIMER.dpto_cnt_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(plusOp[3]),
        .Q(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg [3]),
        .R(clear));
  c6v_return_state_gpio_0_address_decoder I_DECODER
       (.Bus_RNW_reg_reg_0(bus2ip_rnw_i_reg_0),
        .D(D),
        .\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg (\Dual.ALLIN0_ND_G0.READ_REG_GEN[0].reg1_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[0].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[10].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[11].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[12].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[13].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[14].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[15].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[16].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[17].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[18].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[19].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[1].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[20].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[21].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[22].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[23].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[24].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[25].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[26].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[27].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[28].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[29].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[2].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[30].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[31].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[3].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[4].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[5].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[6].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[7].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[8].reg3_reg ),
        .\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg (\Dual.ALLIN0_ND_G2.READ_REG2_GEN[9].reg3_reg ),
        .\Dual.gpio2_OE_reg[0] ({bus2ip_addr[0],bus2ip_addr[5],bus2ip_addr[6]}),
        .\Dual.gpio_Data_In_reg[0] (\Dual.gpio_Data_In_reg[0] ),
        .\Dual.gpio_OE_reg[0] (\Dual.gpio_OE_reg[0] ),
        .E(E),
        .\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1]_0 (\GEN_BKEND_CE_REGISTERS[1].ce_out_i_reg[1] ),
        .GPIO_xferAck_i(GPIO_xferAck_i),
        .\MEM_DECODE_GEN[0].cs_out_i_reg[0]_0 (\MEM_DECODE_GEN[0].cs_out_i_reg[0] ),
        .Q(start2),
        .gpio_Data_In(gpio_Data_In),
        .gpio_xferAck_Reg(gpio_xferAck_Reg),
        .ip2bus_rdack_i_D1(ip2bus_rdack_i_D1),
        .ip2bus_rdack_i_D1_reg(ip2bus_rdack_i_D1_reg),
        .ip2bus_wrack_i_D1(ip2bus_wrack_i_D1),
        .ip2bus_wrack_i_D1_reg(ip2bus_wrack_i_D1_reg),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arready(is_read_reg_n_0),
        .s_axi_arready_0(\INCLUDE_DPHASE_TIMER.dpto_cnt_reg ),
        .s_axi_awready(is_write_reg_n_0),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wdata_0_sp_1(s_axi_wdata_0_sn_1));
  LUT3 #(
    .INIT(8'hAC)) 
    \bus2ip_addr_i[2]_i_1 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_awaddr[0]),
        .I2(s_axi_arvalid),
        .O(p_1_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \bus2ip_addr_i[3]_i_1 
       (.I0(s_axi_araddr[1]),
        .I1(s_axi_awaddr[1]),
        .I2(s_axi_arvalid),
        .O(p_1_in[3]));
  LUT5 #(
    .INIT(32'h000000EA)) 
    \bus2ip_addr_i[8]_i_1 
       (.I0(s_axi_arvalid),
        .I1(s_axi_awvalid),
        .I2(s_axi_wvalid),
        .I3(\state_reg_n_0_[1] ),
        .I4(\state_reg_n_0_[0] ),
        .O(\bus2ip_addr_i[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hAC)) 
    \bus2ip_addr_i[8]_i_2 
       (.I0(s_axi_araddr[2]),
        .I1(s_axi_awaddr[2]),
        .I2(s_axi_arvalid),
        .O(p_1_in[8]));
  FDRE \bus2ip_addr_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[8]_i_1_n_0 ),
        .D(p_1_in[2]),
        .Q(bus2ip_addr[6]),
        .R(SR));
  FDRE \bus2ip_addr_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[8]_i_1_n_0 ),
        .D(p_1_in[3]),
        .Q(bus2ip_addr[5]),
        .R(SR));
  FDRE \bus2ip_addr_i_reg[8] 
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[8]_i_1_n_0 ),
        .D(p_1_in[8]),
        .Q(bus2ip_addr[0]),
        .R(SR));
  FDRE bus2ip_rnw_i_reg
       (.C(s_axi_aclk),
        .CE(\bus2ip_addr_i[8]_i_1_n_0 ),
        .D(s_axi_arvalid),
        .Q(bus2ip_rnw_i_reg_0),
        .R(SR));
  LUT5 #(
    .INIT(32'h8BBB8888)) 
    is_read_i_1
       (.I0(s_axi_arvalid),
        .I1(\FSM_onehot_state_reg_n_0_[0] ),
        .I2(state1__2),
        .I3(\FSM_onehot_state_reg_n_0_[3] ),
        .I4(is_read_reg_n_0),
        .O(is_read_i_1_n_0));
  FDRE is_read_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(is_read_i_1_n_0),
        .Q(is_read_reg_n_0),
        .R(SR));
  LUT6 #(
    .INIT(64'h2000FFFF20000000)) 
    is_write_i_1
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(s_axi_arvalid),
        .I2(s_axi_awvalid),
        .I3(s_axi_wvalid),
        .I4(is_write_i_2_n_0),
        .I5(is_write_reg_n_0),
        .O(is_write_i_1_n_0));
  LUT6 #(
    .INIT(64'hFFEAEAEAAAAAAAAA)) 
    is_write_i_2
       (.I0(\FSM_onehot_state_reg_n_0_[0] ),
        .I1(s_axi_bready),
        .I2(s_axi_bvalid_i_reg_0),
        .I3(s_axi_rready),
        .I4(s_axi_rvalid_i_reg_0),
        .I5(\FSM_onehot_state_reg_n_0_[3] ),
        .O(is_write_i_2_n_0));
  FDRE is_write_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(is_write_i_1_n_0),
        .Q(is_write_reg_n_0),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    rst_i_1
       (.I0(s_axi_aresetn),
        .O(rst_i_1_n_0));
  FDRE rst_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rst_i_1_n_0),
        .Q(SR),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h08FF0808)) 
    s_axi_bvalid_i_i_1
       (.I0(ip2bus_wrack_i_D1_reg),
        .I1(\state_reg_n_0_[1] ),
        .I2(\state_reg_n_0_[0] ),
        .I3(s_axi_bready),
        .I4(s_axi_bvalid_i_reg_0),
        .O(s_axi_bvalid_i_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axi_bvalid_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_bvalid_i_i_1_n_0),
        .Q(s_axi_bvalid_i_reg_0),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[0] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [0]),
        .Q(s_axi_rdata[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[10] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [10]),
        .Q(s_axi_rdata[10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[11] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [11]),
        .Q(s_axi_rdata[11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[12] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [12]),
        .Q(s_axi_rdata[12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[13] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [13]),
        .Q(s_axi_rdata[13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[14] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [14]),
        .Q(s_axi_rdata[14]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[15] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [15]),
        .Q(s_axi_rdata[15]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[16] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [16]),
        .Q(s_axi_rdata[16]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[17] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [17]),
        .Q(s_axi_rdata[17]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[18] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [18]),
        .Q(s_axi_rdata[18]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[19] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [19]),
        .Q(s_axi_rdata[19]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[1] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [1]),
        .Q(s_axi_rdata[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[20] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [20]),
        .Q(s_axi_rdata[20]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[21] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [21]),
        .Q(s_axi_rdata[21]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[22] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [22]),
        .Q(s_axi_rdata[22]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[23] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [23]),
        .Q(s_axi_rdata[23]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[24] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [24]),
        .Q(s_axi_rdata[24]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[25] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [25]),
        .Q(s_axi_rdata[25]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[26] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [26]),
        .Q(s_axi_rdata[26]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[27] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [27]),
        .Q(s_axi_rdata[27]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[28] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [28]),
        .Q(s_axi_rdata[28]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[29] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [29]),
        .Q(s_axi_rdata[29]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[2] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [2]),
        .Q(s_axi_rdata[2]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[30] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [30]),
        .Q(s_axi_rdata[30]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[31] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [31]),
        .Q(s_axi_rdata[31]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[3] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [3]),
        .Q(s_axi_rdata[3]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[4] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [4]),
        .Q(s_axi_rdata[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[5] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [5]),
        .Q(s_axi_rdata[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[6] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [6]),
        .Q(s_axi_rdata[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[7] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [7]),
        .Q(s_axi_rdata[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[8] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [8]),
        .Q(s_axi_rdata[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \s_axi_rdata_i_reg[9] 
       (.C(s_axi_aclk),
        .CE(s_axi_rresp_i),
        .D(\s_axi_rdata_i_reg[31]_0 [9]),
        .Q(s_axi_rdata[9]),
        .R(SR));
  LUT5 #(
    .INIT(32'h08FF0808)) 
    s_axi_rvalid_i_i_1
       (.I0(ip2bus_rdack_i_D1_reg),
        .I1(\state_reg_n_0_[0] ),
        .I2(\state_reg_n_0_[1] ),
        .I3(s_axi_rready),
        .I4(s_axi_rvalid_i_reg_0),
        .O(s_axi_rvalid_i_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    s_axi_rvalid_i_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_rvalid_i_i_1_n_0),
        .Q(s_axi_rvalid_i_reg_0),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'h000000F8)) 
    start2_i_1
       (.I0(s_axi_awvalid),
        .I1(s_axi_wvalid),
        .I2(s_axi_arvalid),
        .I3(\state_reg_n_0_[1] ),
        .I4(\state_reg_n_0_[0] ),
        .O(start2_i_1_n_0));
  FDRE start2_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(start2_i_1_n_0),
        .Q(start2),
        .R(SR));
  LUT5 #(
    .INIT(32'h0FCAFFCA)) 
    \state[0]_i_1 
       (.I0(s_axi_arvalid),
        .I1(ip2bus_wrack_i_D1_reg),
        .I2(\state_reg_n_0_[1] ),
        .I3(\state_reg_n_0_[0] ),
        .I4(state1__2),
        .O(\state[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h55FFFF0C5500FF0C)) 
    \state[1]_i_1 
       (.I0(state1__2),
        .I1(p_5_in),
        .I2(s_axi_arvalid),
        .I3(\state_reg_n_0_[1] ),
        .I4(\state_reg_n_0_[0] ),
        .I5(ip2bus_rdack_i_D1_reg),
        .O(\state[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \state[1]_i_2 
       (.I0(s_axi_awvalid),
        .I1(s_axi_wvalid),
        .O(p_5_in));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\state[0]_i_1_n_0 ),
        .Q(\state_reg_n_0_[0] ),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \state_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\state[1]_i_1_n_0 ),
        .Q(\state_reg_n_0_[1] ),
        .R(SR));
endmodule

(* DEST_SYNC_FF = "4" *) (* INIT_SYNC_FF = "0" *) (* SIM_ASSERT_CHK = "0" *) 
(* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) (* WIDTH = "1" *) 
(* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) (* xpm_cdc = "ARRAY_SINGLE" *) 
module c6v_return_state_gpio_0_xpm_cdc_array_single
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input [0:0]src_in;
  input dest_clk;
  output [0:0]dest_out;

  wire [0:0]async_path_bit;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [0:0]\syncstages_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [0:0]\syncstages_ff[1] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [0:0]\syncstages_ff[2] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [0:0]\syncstages_ff[3] ;

  assign async_path_bit = src_in[0];
  assign dest_out[0] = \syncstages_ff[3] ;
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit),
        .Q(\syncstages_ff[0] ),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] ),
        .Q(\syncstages_ff[1] ),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] ),
        .Q(\syncstages_ff[2] ),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] ),
        .Q(\syncstages_ff[3] ),
        .R(1'b0));
endmodule

(* DEST_SYNC_FF = "4" *) (* INIT_SYNC_FF = "0" *) (* ORIG_REF_NAME = "xpm_cdc_array_single" *) 
(* SIM_ASSERT_CHK = "0" *) (* SRC_INPUT_REG = "0" *) (* VERSION = "0" *) 
(* WIDTH = "32" *) (* XPM_MODULE = "TRUE" *) (* keep_hierarchy = "soft" *) 
(* xpm_cdc = "ARRAY_SINGLE" *) 
module c6v_return_state_gpio_0_xpm_cdc_array_single__parameterized1
   (src_clk,
    src_in,
    dest_clk,
    dest_out);
  input src_clk;
  input [31:0]src_in;
  input dest_clk;
  output [31:0]dest_out;

  wire [31:0]async_path_bit;
  wire dest_clk;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [31:0]\syncstages_ff[0] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [31:0]\syncstages_ff[1] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [31:0]\syncstages_ff[2] ;
  (* RTL_KEEP = "true" *) (* async_reg = "true" *) (* xpm_cdc = "ARRAY_SINGLE" *) wire [31:0]\syncstages_ff[3] ;

  assign async_path_bit = src_in[31:0];
  assign dest_out[31:0] = \syncstages_ff[3] ;
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[0]),
        .Q(\syncstages_ff[0] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[10]),
        .Q(\syncstages_ff[0] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[11]),
        .Q(\syncstages_ff[0] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][12] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[12]),
        .Q(\syncstages_ff[0] [12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][13] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[13]),
        .Q(\syncstages_ff[0] [13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][14] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[14]),
        .Q(\syncstages_ff[0] [14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][15] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[15]),
        .Q(\syncstages_ff[0] [15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][16] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[16]),
        .Q(\syncstages_ff[0] [16]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][17] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[17]),
        .Q(\syncstages_ff[0] [17]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][18] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[18]),
        .Q(\syncstages_ff[0] [18]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][19] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[19]),
        .Q(\syncstages_ff[0] [19]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[1]),
        .Q(\syncstages_ff[0] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][20] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[20]),
        .Q(\syncstages_ff[0] [20]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][21] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[21]),
        .Q(\syncstages_ff[0] [21]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][22] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[22]),
        .Q(\syncstages_ff[0] [22]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][23] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[23]),
        .Q(\syncstages_ff[0] [23]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][24] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[24]),
        .Q(\syncstages_ff[0] [24]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][25] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[25]),
        .Q(\syncstages_ff[0] [25]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][26] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[26]),
        .Q(\syncstages_ff[0] [26]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][27] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[27]),
        .Q(\syncstages_ff[0] [27]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][28] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[28]),
        .Q(\syncstages_ff[0] [28]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][29] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[29]),
        .Q(\syncstages_ff[0] [29]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[2]),
        .Q(\syncstages_ff[0] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][30] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[30]),
        .Q(\syncstages_ff[0] [30]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][31] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[31]),
        .Q(\syncstages_ff[0] [31]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[3]),
        .Q(\syncstages_ff[0] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[4]),
        .Q(\syncstages_ff[0] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[5]),
        .Q(\syncstages_ff[0] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[6]),
        .Q(\syncstages_ff[0] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[7]),
        .Q(\syncstages_ff[0] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[8]),
        .Q(\syncstages_ff[0] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[0][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(async_path_bit[9]),
        .Q(\syncstages_ff[0] [9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [0]),
        .Q(\syncstages_ff[1] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [10]),
        .Q(\syncstages_ff[1] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [11]),
        .Q(\syncstages_ff[1] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][12] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [12]),
        .Q(\syncstages_ff[1] [12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][13] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [13]),
        .Q(\syncstages_ff[1] [13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][14] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [14]),
        .Q(\syncstages_ff[1] [14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][15] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [15]),
        .Q(\syncstages_ff[1] [15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][16] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [16]),
        .Q(\syncstages_ff[1] [16]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][17] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [17]),
        .Q(\syncstages_ff[1] [17]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][18] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [18]),
        .Q(\syncstages_ff[1] [18]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][19] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [19]),
        .Q(\syncstages_ff[1] [19]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [1]),
        .Q(\syncstages_ff[1] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][20] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [20]),
        .Q(\syncstages_ff[1] [20]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][21] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [21]),
        .Q(\syncstages_ff[1] [21]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][22] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [22]),
        .Q(\syncstages_ff[1] [22]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][23] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [23]),
        .Q(\syncstages_ff[1] [23]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][24] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [24]),
        .Q(\syncstages_ff[1] [24]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][25] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [25]),
        .Q(\syncstages_ff[1] [25]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][26] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [26]),
        .Q(\syncstages_ff[1] [26]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][27] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [27]),
        .Q(\syncstages_ff[1] [27]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][28] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [28]),
        .Q(\syncstages_ff[1] [28]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][29] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [29]),
        .Q(\syncstages_ff[1] [29]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [2]),
        .Q(\syncstages_ff[1] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][30] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [30]),
        .Q(\syncstages_ff[1] [30]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][31] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [31]),
        .Q(\syncstages_ff[1] [31]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [3]),
        .Q(\syncstages_ff[1] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [4]),
        .Q(\syncstages_ff[1] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [5]),
        .Q(\syncstages_ff[1] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [6]),
        .Q(\syncstages_ff[1] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [7]),
        .Q(\syncstages_ff[1] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [8]),
        .Q(\syncstages_ff[1] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[1][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[0] [9]),
        .Q(\syncstages_ff[1] [9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [0]),
        .Q(\syncstages_ff[2] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [10]),
        .Q(\syncstages_ff[2] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [11]),
        .Q(\syncstages_ff[2] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][12] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [12]),
        .Q(\syncstages_ff[2] [12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][13] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [13]),
        .Q(\syncstages_ff[2] [13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][14] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [14]),
        .Q(\syncstages_ff[2] [14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][15] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [15]),
        .Q(\syncstages_ff[2] [15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][16] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [16]),
        .Q(\syncstages_ff[2] [16]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][17] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [17]),
        .Q(\syncstages_ff[2] [17]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][18] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [18]),
        .Q(\syncstages_ff[2] [18]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][19] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [19]),
        .Q(\syncstages_ff[2] [19]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [1]),
        .Q(\syncstages_ff[2] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][20] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [20]),
        .Q(\syncstages_ff[2] [20]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][21] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [21]),
        .Q(\syncstages_ff[2] [21]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][22] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [22]),
        .Q(\syncstages_ff[2] [22]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][23] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [23]),
        .Q(\syncstages_ff[2] [23]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][24] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [24]),
        .Q(\syncstages_ff[2] [24]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][25] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [25]),
        .Q(\syncstages_ff[2] [25]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][26] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [26]),
        .Q(\syncstages_ff[2] [26]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][27] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [27]),
        .Q(\syncstages_ff[2] [27]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][28] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [28]),
        .Q(\syncstages_ff[2] [28]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][29] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [29]),
        .Q(\syncstages_ff[2] [29]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [2]),
        .Q(\syncstages_ff[2] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][30] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [30]),
        .Q(\syncstages_ff[2] [30]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][31] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [31]),
        .Q(\syncstages_ff[2] [31]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [3]),
        .Q(\syncstages_ff[2] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [4]),
        .Q(\syncstages_ff[2] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [5]),
        .Q(\syncstages_ff[2] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [6]),
        .Q(\syncstages_ff[2] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [7]),
        .Q(\syncstages_ff[2] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [8]),
        .Q(\syncstages_ff[2] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[2][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[1] [9]),
        .Q(\syncstages_ff[2] [9]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][0] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [0]),
        .Q(\syncstages_ff[3] [0]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][10] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [10]),
        .Q(\syncstages_ff[3] [10]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][11] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [11]),
        .Q(\syncstages_ff[3] [11]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][12] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [12]),
        .Q(\syncstages_ff[3] [12]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][13] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [13]),
        .Q(\syncstages_ff[3] [13]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][14] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [14]),
        .Q(\syncstages_ff[3] [14]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][15] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [15]),
        .Q(\syncstages_ff[3] [15]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][16] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [16]),
        .Q(\syncstages_ff[3] [16]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][17] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [17]),
        .Q(\syncstages_ff[3] [17]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][18] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [18]),
        .Q(\syncstages_ff[3] [18]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][19] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [19]),
        .Q(\syncstages_ff[3] [19]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][1] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [1]),
        .Q(\syncstages_ff[3] [1]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][20] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [20]),
        .Q(\syncstages_ff[3] [20]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][21] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [21]),
        .Q(\syncstages_ff[3] [21]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][22] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [22]),
        .Q(\syncstages_ff[3] [22]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][23] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [23]),
        .Q(\syncstages_ff[3] [23]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][24] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [24]),
        .Q(\syncstages_ff[3] [24]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][25] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [25]),
        .Q(\syncstages_ff[3] [25]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][26] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [26]),
        .Q(\syncstages_ff[3] [26]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][27] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [27]),
        .Q(\syncstages_ff[3] [27]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][28] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [28]),
        .Q(\syncstages_ff[3] [28]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][29] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [29]),
        .Q(\syncstages_ff[3] [29]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][2] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [2]),
        .Q(\syncstages_ff[3] [2]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][30] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [30]),
        .Q(\syncstages_ff[3] [30]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][31] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [31]),
        .Q(\syncstages_ff[3] [31]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][3] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [3]),
        .Q(\syncstages_ff[3] [3]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][4] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [4]),
        .Q(\syncstages_ff[3] [4]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][5] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [5]),
        .Q(\syncstages_ff[3] [5]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][6] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [6]),
        .Q(\syncstages_ff[3] [6]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][7] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [7]),
        .Q(\syncstages_ff[3] [7]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][8] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [8]),
        .Q(\syncstages_ff[3] [8]),
        .R(1'b0));
  (* ASYNC_REG *) 
  (* KEEP = "true" *) 
  (* XPM_CDC = "ARRAY_SINGLE" *) 
  FDRE \syncstages_ff_reg[3][9] 
       (.C(dest_clk),
        .CE(1'b1),
        .D(\syncstages_ff[2] [9]),
        .Q(\syncstages_ff[3] [9]),
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
