`timescale 1ns/1ps
// Real C0E BD and PS7 VIP. BAD_READ proves a reset-held AXI read cannot return.
// Default proves safe independent-DMA checks -> reset release -> bounded MMIO.
module tb_c0e_arm;
    localparam BAD_READ=0;
    reg ps_clock=0, reset_n=0, camera_clock=0;
    always #15 ps_clock=~ps_clock;
    always #6.734 camera_clock=~camera_clock;
    wire ps_clock_pin=ps_clock;
    wire reset_pin=reset_n;
    wire fabric_clock=dut.c6v_i.ps7_0_FCLK_CLK0;
    wire capture_reset_n=dut.c6v_i.capture_control.s_axi_aresetn;
    tri1 camera_scl,camera_sda,codec_scl,codec_sda;
    c6v_wrapper dut (
        .FIXED_IO_ps_clk(ps_clock_pin),.FIXED_IO_ps_porb(reset_pin),.FIXED_IO_ps_srstb(reset_pin),
        .sdata_i(1'b0),.vid_pclk(camera_clock),.vid_data(8'd0),.vid_hsync(1'b0),.vid_vsync(1'b0),
        .vid_iic_scl_io(camera_scl),.vid_iic_sda_io(camera_sda),
        .IIC_1_scl_io(codec_scl),.IIC_1_sda_io(codec_sda)
    );
    integer reads=0,writes=0,phase=0,blocked_cycles=0;
    reg [31:0] current_address=0,value;
    reg bad_completed=0;
    reg [1023:0] bad_value;
    reg [1:0] bad_response;
    always @(posedge fabric_clock)
        if (!capture_reset_n && dut.c6v_i.capture_status.s_axi_arvalid &&
            !dut.c6v_i.capture_status.s_axi_arready) blocked_cycles=blocked_cycles+1;

    task automatic read_register(input [31:0] address,output [31:0] result);
        reg [1023:0] raw;
        reg [1:0] response;
        current_address=address;
        fork
            dut.c6v_i.ps7_0.inst.read_data(address,4,raw,response);
            begin
                repeat(2000) @(negedge fabric_clock);
                $fatal(1,"C0E_READ_TIMEOUT phase=%0d address=%h",phase,address);
            end
        join_any
        disable fork;
        if(response!==0) $fatal(1,"C0E_READ_RESPONSE address=%h response=%h",address,response);
        result=raw[31:0];reads=reads+1;
    endtask

    task automatic expect_register(input [31:0] address,input [31:0] expected);
        reg [31:0] actual;
        read_register(address,actual);
        if(actual!==expected) $fatal(1,"C0E_READ_VALUE address=%h expected=%h actual=%h",address,expected,actual);
    endtask

    task automatic write_register(input [31:0] address,input [31:0] data);
        reg [1:0] response;
        current_address=address;
        fork
            dut.c6v_i.ps7_0.inst.write_data(address,4,{992'd0,data},response);
            begin
                repeat(2000) @(negedge fabric_clock);
                $fatal(1,"C0E_WRITE_TIMEOUT phase=%0d address=%h",phase,address);
            end
        join_any
        disable fork;
        if(response!==0) $fatal(1,"C0E_WRITE_RESPONSE address=%h response=%h",address,response);
        writes=writes+1;
    endtask

    initial begin
        $display("C0E_RESET_CASE BAD_READ=%0d",BAD_READ);
        if(BAD_READ!=0 && BAD_READ!=1) $fatal(1,"C0E_RESET_CASE_INVALID");
        #500 reset_n=1;
        #500 dut.c6v_i.ps7_0.inst.fpga_soft_reset('hf);
        #1000 dut.c6v_i.ps7_0.inst.fpga_soft_reset(0);
        repeat(3000) @(negedge fabric_clock);
        phase=1;
        expect_register(32'h41200000,32'hc0060e00);
        expect_register(32'h43c10000,32'h564f4c31);
        // These DMA interfaces must respond independently of the capture reset.
        read_register(32'h43000030,value);
        if(value & 5) $fatal(1,"C0E_RGB_DMA_NOT_IDLE_CONTROL");
        read_register(32'h43000034,value);
        if((value & 1)!==1 || (value & 'hc9f0)!==0) $fatal(1,"C0E_RGB_DMA_NOT_HALTED");
        read_register(32'h40420030,value);
        if(value & 5) $fatal(1,"C0E_PACKET_DMA_NOT_IDLE_CONTROL");
        read_register(32'h40420034,value);
        if((value & 9)!==9 || (value & 'h4770)!==0) $fatal(1,"C0E_PACKET_DMA_NOT_HALTED");
        expect_register(32'h413d0000,0);
        if(capture_reset_n!==0) $fatal(1,"C0E_CAPTURE_NOT_HELD_RESET");
        if(BAD_READ) begin
            phase=2;
            fork
                begin
                    dut.c6v_i.ps7_0.inst.read_data(32'h41410000,4,bad_value,bad_response);
                    bad_completed=1;
                end
                begin
                    repeat(1000) @(negedge fabric_clock);
                    if(bad_completed || blocked_cycles<100) $fatal(1,"C0E_RESET_HELD_READ_NOT_PROVEN cycles=%0d",blocked_cycles);
                    $display("TEST_PASS C0E_RESET_HELD_READ_BLOCKED blocked_cycles=%0d",blocked_cycles);
                    $finish;
                end
            join
        end else begin
            // Actual software context packing, then ARM, with video inactive.
            write_register(32'h413d0004,0);
            write_register(32'h413d0000,1);
            repeat(8) @(negedge fabric_clock);
            expect_register(32'h413f0000,32'h31435456);
            expect_register(32'h413f0004,32'h00020000);
            expect_register(32'h41410010,0);
            write_register(32'h413f0020,32'hff141400);
            write_register(32'h413f0024,32'h0001ff46);
            write_register(32'h413f0028,32'h00010000);
            write_register(32'h413f002c,32'h56780000);
            write_register(32'h413f0030,32'h00001234);
            expect_register(32'h413f000c,32'h1f);
            write_register(32'h413f0010,1);
            expect_register(32'h413f0008,1);
            for(integer sample=0;sample<10;sample=sample+1) begin
                repeat(1000) @(negedge fabric_clock);
                read_register(32'h41410008,value);
                $display("C0E_ARM_SAMPLE sample=%0d flags=%h",sample,value);
                if(value!==1) $fatal(1,"C0E_ARM_STATUS_REJECTED flags=%h",value);
                expect_register(32'h4141000c,0);
                expect_register(32'h41410010,32'h12345678);
                expect_register(32'h413f0064,0);
            end
            $display("TEST_PASS C0E_ARM_NO_VIDEO_STABLE reads=%0d writes=%0d",reads,writes);
            $finish;
        end
    end
    initial begin #1000000; $fatal(1,"C0E_RESET_WATCHDOG phase=%0d address=%h",phase,current_address); end
endmodule
