`timescale 1ns/1ps
// R21 OSD MMIO read while pixel reset is held. Mimics InputOsdService.open.
module tb_osd_axi_pixel_reset;
`ifdef EXPECT_BLOCKED
    localparam integer EXPECT_BLOCKED_VALUE=1;
`else
    localparam integer EXPECT_BLOCKED_VALUE=0;
`endif
    reg aclk=0,pclk=0,aresetn=0,presetn=0;
    always #5 aclk=~aclk;
    always #7 pclk=~pclk;
    reg [6:0] araddr=0;
    reg arvalid=0,rready=0;
    reg [6:0] awaddr=0;
    reg awvalid=0,wvalid=0,bready=0;
    reg [31:0] wdata=0;
    reg [3:0] wstrb=4'hf;
    wire arready,rvalid;
    wire [31:0] rdata;
    wire [1:0] rresp;
    wire awready,wready,bvalid;
    wire [1:0] bresp;
    wire [23:0] out_rgb;
    wire out_de,out_hs,out_vs;
    input_osd_axi dut(
        .s_axi_aclk(aclk),.s_axi_aresetn(aresetn),
        .pclk(pclk),.presetn(presetn),
        .s_axi_awaddr(awaddr),.s_axi_awprot(3'd0),.s_axi_awvalid(awvalid),.s_axi_awready(awready),
        .s_axi_wdata(wdata),.s_axi_wstrb(wstrb),.s_axi_wvalid(wvalid),.s_axi_wready(wready),
        .s_axi_bresp(bresp),.s_axi_bvalid(bvalid),.s_axi_bready(bready),
        .s_axi_araddr(araddr),.s_axi_arprot(3'd0),.s_axi_arvalid(arvalid),.s_axi_arready(arready),
        .s_axi_rdata(rdata),.s_axi_rresp(rresp),.s_axi_rvalid(rvalid),.s_axi_rready(rready),
        .in_rgb(24'd0),.in_de(1'b0),.in_hs(1'b0),.in_vs(1'b0),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs));

    task automatic request_read(input [6:0] address);
        integer cycles;
        begin
            @(negedge aclk); araddr=address; arvalid=1;
            cycles=0;
            do begin
                @(posedge aclk); cycles=cycles+1;
                if(cycles>16) $fatal(1,"AR never accepted");
            end while(!arready);
            @(negedge aclk); arvalid=0;
        end
    endtask

    task automatic await_response(input bit expected, input [31:0] expected_data);
        integer cycles;
        bit seen;
        begin
            seen=0;
            for(cycles=0;cycles<32;cycles=cycles+1) begin
                @(negedge aclk);
                if(rvalid) begin
                    if(rresp!==0 || rdata!==expected_data)
                        $fatal(1,"OSD read response invalid: data=%h resp=%h expected=%h",
                               rdata,rresp,expected_data);
                    seen=1;
                    break;
                end
            end
            if(seen!==expected)
                $fatal(1,"OSD ID response mismatch while pixel reset held=%b expected=%b seen=%b",
                       !presetn,expected,seen);
            if(seen) begin
                rready=1;
                @(negedge aclk); rready=0;
            end
        end
    endtask

    task automatic write_word(input [6:0] address, input [31:0] data);
        integer cycles;
        begin
            @(negedge aclk);
            awaddr=address;wdata=data;awvalid=1;wvalid=1;
            cycles=0;
            do begin
                @(posedge aclk); cycles=cycles+1;
                if(cycles>16) $fatal(1,"write address/data never accepted");
            end while(!(awready && wready));
            @(negedge aclk);awvalid=0;wvalid=0;
            cycles=0;
            while(!bvalid) begin
                @(negedge aclk);cycles=cycles+1;
                if(cycles>16) $fatal(1,"write response missing");
            end
            if(bresp!==0) $fatal(1,"write response error: %h",bresp);
            bready=1;
            @(negedge aclk);bready=0;
        end
    endtask

    initial begin
        repeat(6) @(negedge aclk);
        aresetn=1;
        repeat(6) @(negedge aclk);
        if(presetn!==0) $fatal(1,"test requires pixel reset held");
        request_read(7'h00);
`ifdef EXPECT_BLOCKED
        await_response(0,32'h4f534401);
        $display("REPRODUCED R21_OSD_ID_READ_BLOCKED pixel_reset=0 axi_reset=1");
`else
        await_response(1,32'h4f534401);
        $display("REPAIRED R21_OSD_ID_READ_RESPONSIVE pixel_reset=0 axi_reset=1");
        write_word(7'h10,32'h12345678);
        request_read(7'h10);await_response(1,32'h00000000);
`endif
        @(negedge pclk); presetn=1;
        repeat(8) @(negedge aclk);
`ifndef EXPECT_BLOCKED
        write_word(7'h10,32'h12345678);
        request_read(7'h10);await_response(1,32'h12345678);
        write_word(7'h08,32'h00000001);
        request_read(7'h04);await_response(1,32'h00000001);
        @(negedge pclk);presetn=0;
        repeat(8) @(negedge aclk);
        request_read(7'h04);await_response(1,32'h00000000);
        request_read(7'h10);await_response(1,32'h00000000);
        @(negedge pclk);presetn=1;
        repeat(8) @(negedge aclk);
        $display("OSD_PIXEL_RESET_FLUSH_PASS");
`endif
        request_read(7'h00);
        await_response(1,32'h4f534401);
        $display("TEST_PASS OSD_AXI_PIXEL_RESET expected_blocked=%0d", EXPECT_BLOCKED_VALUE);
        $finish;
    end
    initial begin #20000; $fatal(1,"OSD_PIXEL_RESET_WATCHDOG"); end
endmodule
