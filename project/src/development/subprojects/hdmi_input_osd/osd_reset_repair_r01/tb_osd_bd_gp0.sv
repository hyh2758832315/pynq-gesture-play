`timescale 1ns/1ps
// Full generated C6V BD: PS7 BFM -> GP0 slice -> two SmartConnects -> R22 OSD.
module tb_osd_bd_gp0;
    reg ps_clock=0, reset_n=0, camera_clock=0;
    always #15 ps_clock=~ps_clock;
    always #6.734 camera_clock=~camera_clock;
    wire ps_clock_pin=ps_clock, reset_pin=reset_n;
    tri1 camera_scl,camera_sda,codec_scl,codec_sda;
    wire fabric_clock=dut.c6v_i.ps7_0_FCLK_CLK0;
    wire axi_resetn=dut.c6v_i.rst_fclk0_peripheral_aresetn[0];
    wire pixel_resetn=dut.c6v_i.rst_pixel_peripheral_aresetn[0];
    c6v_wrapper dut(
        .FIXED_IO_ps_clk(ps_clock_pin),.FIXED_IO_ps_porb(reset_pin),.FIXED_IO_ps_srstb(reset_pin),
        .sdata_i(1'b0),.vid_pclk(camera_clock),.vid_data(8'd0),
        .vid_hsync(1'b0),.vid_vsync(1'b0),
        .vid_iic_scl_io(camera_scl),.vid_iic_sda_io(camera_sda),
        .IIC_1_scl_io(codec_scl),.IIC_1_sda_io(codec_sda));

    localparam [31:0] OSD=32'h43c20000;
    integer reads=0,writes=0,ps_ar=0,ps_r=0,osd_ar=0,osd_r=0;
    reg [31:0] current_address=0;
    always @(posedge fabric_clock) begin
        if(dut.c6v_i.ps7_0.M_AXI_GP0_ARVALID && dut.c6v_i.ps7_0.M_AXI_GP0_ARREADY)
            ps_ar=ps_ar+1;
        if(dut.c6v_i.ps7_0.M_AXI_GP0_RVALID && dut.c6v_i.ps7_0.M_AXI_GP0_RREADY)
            ps_r=ps_r+1;
        if(dut.c6v_i.input_osd_0.s_axi_arvalid && dut.c6v_i.input_osd_0.s_axi_arready)
            osd_ar=osd_ar+1;
        if(dut.c6v_i.input_osd_0.s_axi_rvalid && dut.c6v_i.input_osd_0.s_axi_rready)
            osd_r=osd_r+1;
    end
    task automatic read32(input [31:0] address,input [31:0] expected);
        reg [1023:0] raw;
        reg [1:0] response;
        current_address=address;
        fork
            dut.c6v_i.ps7_0.inst.read_data(address,4,raw,response);
            begin
                repeat(2000) @(negedge fabric_clock);
                $fatal(1,"OSD_BD_READ_TIMEOUT addr=%h axi_resetn=%b pixel_resetn=%b ps_ar=%0d ps_r=%0d osd_ar=%0d osd_r=%0d",
                    address,axi_resetn,pixel_resetn,ps_ar,ps_r,osd_ar,osd_r);
            end
        join_any
        disable fork;
        if(response!==0 || raw[31:0]!==expected)
            $fatal(1,"OSD_BD_READ_MISMATCH addr=%h expected=%h actual=%h resp=%b",
                address,expected,raw[31:0],response);
        reads=reads+1;
    endtask
    task automatic write32(input [31:0] address,input [31:0] data);
        reg [1:0] response;
        current_address=address;
        fork
            dut.c6v_i.ps7_0.inst.write_data(address,4,{992'd0,data},response);
            begin
                repeat(2000) @(negedge fabric_clock);
                $fatal(1,"OSD_BD_WRITE_TIMEOUT addr=%h",address);
            end
        join_any
        disable fork;
        if(response!==0) $fatal(1,"OSD_BD_WRITE_RESP addr=%h resp=%b",address,response);
        writes=writes+1;
    endtask
    initial begin
        #500 reset_n=1;
        #500 dut.c6v_i.ps7_0.inst.fpga_soft_reset('hf);
        #1000 dut.c6v_i.ps7_0.inst.fpga_soft_reset(0);
        repeat(3000) @(negedge fabric_clock);
        if(axi_resetn!==1) $fatal(1,"OSD_BD_AXI_RESET_HELD");
        read32(32'h41200000,32'hc0060e00);
        read32(OSD+0,32'h4f534401);
        read32(OSD+4,0);
        force dut.c6v_i.input_osd_0.presetn=1'b0;
        repeat(8) @(negedge fabric_clock);
        if(dut.c6v_i.input_osd_0.presetn!==0) $fatal(1,"OSD_BD_PIXEL_RESET_FORCE_FAILED");
        read32(OSD+0,32'h4f534401);
        read32(OSD+4,0);
        release dut.c6v_i.input_osd_0.presetn;
        for(integer i=0;i<100;i=i+1) begin
            read32(OSD+0,32'h4f534401);
            read32(OSD+4,0);
        end
        for(integer i=0;i<6;i=i+1) write32(OSD+16+4*i,i==0 ? 1 : 0);
        write32(OSD+8,1);
        read32(OSD+4,1); // no frame boundary has acknowledged this commit
        $display("TEST_PASS OSD_BD_GP0 reads=%0d writes=%0d ps_ar=%0d ps_r=%0d osd_ar=%0d osd_r=%0d",
            reads,writes,ps_ar,ps_r,osd_ar,osd_r);
        $finish;
    end
    initial begin
        #10000000;
        $fatal(1,"OSD_BD_WATCHDOG addr=%h reads=%0d writes=%0d",current_address,reads,writes);
    end
endmodule
