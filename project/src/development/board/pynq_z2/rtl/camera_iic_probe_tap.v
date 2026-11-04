module camera_iic_probe_tap (
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SCL_I", X_INTERFACE_MODE = "Slave" *) output wire core_scl_i,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SCL_O" *) input wire core_scl_o,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SCL_T" *) input wire core_scl_t,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SDA_I" *) output wire core_sda_i,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SDA_O" *) input wire core_sda_o,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 core_iic SDA_T" *) input wire core_sda_t,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SCL_I", X_INTERFACE_MODE = "Master" *) input wire port_scl_i,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SCL_O" *) output wire port_scl_o,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SCL_T" *) output wire port_scl_t,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SDA_I" *) input wire port_sda_i,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SDA_O" *) output wire port_sda_o,
    (* X_INTERFACE_INFO = "xilinx.com:interface:iic:1.0 port_iic SDA_T" *) output wire port_sda_t,
    output wire [5:0] probe
);

assign core_scl_i = port_scl_i;
assign core_sda_i = port_sda_i;
assign port_scl_o = core_scl_o;
assign port_scl_t = core_scl_t;
assign port_sda_o = core_sda_o;
assign port_sda_t = core_sda_t;
assign probe = {port_scl_i, core_scl_o, core_scl_t, port_sda_i, core_sda_o, core_sda_t};

endmodule