`timescale 1ns/1ps
// Models actual MMIO sequence, split AW/W arrival, backpressure and reset.
module tb_osd_axi_transactions;
`ifdef GATE_NETLIST
    `define OSD_DUT c6v_input_osd_0_0
`else
    `define OSD_DUT input_osd_axi
`endif
    reg aclk=0,pclk=0,aresetn=0,presetn=0,pclk_enable=1;
    always #5 aclk=~aclk;
    always #7 if(pclk_enable) pclk=~pclk;
    reg [6:0] awaddr=0,araddr=0;
    reg awvalid=0,wvalid=0,bready=0,arvalid=0,rready=0;
    reg [31:0] wdata=0;
    reg [3:0] wstrb=4'hf;
    wire awready,wready,bvalid,arready,rvalid;
    wire [1:0] bresp,rresp;
    wire [31:0] rdata;
    wire [23:0] out_rgb;
    wire out_de,out_hs,out_vs;
    `OSD_DUT dut(
        .s_axi_aclk(aclk),.s_axi_aresetn(aresetn),.pclk(pclk),.presetn(presetn),
        .s_axi_awaddr(awaddr),.s_axi_awprot(3'd0),.s_axi_awvalid(awvalid),.s_axi_awready(awready),
        .s_axi_wdata(wdata),.s_axi_wstrb(wstrb),.s_axi_wvalid(wvalid),.s_axi_wready(wready),
        .s_axi_bresp(bresp),.s_axi_bvalid(bvalid),.s_axi_bready(bready),
        .s_axi_araddr(araddr),.s_axi_arprot(3'd0),.s_axi_arvalid(arvalid),.s_axi_arready(arready),
        .s_axi_rdata(rdata),.s_axi_rresp(rresp),.s_axi_rvalid(rvalid),.s_axi_rready(rready),
        .in_rgb(24'd0),.in_de(1'b0),.in_hs(1'b0),.in_vs(1'b0),
        .out_rgb(out_rgb),.out_de(out_de),.out_hs(out_hs),.out_vs(out_vs));

    integer checks=0;
    task automatic send_aw(input [6:0] addr);
        integer cycles;
        bit accepted;
        begin
            @(negedge aclk);awaddr=addr;awvalid=1;
            accepted=0;
            for(cycles=0;cycles<20;cycles=cycles+1) begin
                @(posedge aclk);
                if(awready) begin accepted=1;break;end
            end
            if(!accepted) $fatal(1,"AW timeout addr=%h",addr);
            @(negedge aclk);awvalid=0;
        end
    endtask
    task automatic send_w(input [31:0] data);
        integer cycles;
        bit accepted;
        begin
            @(negedge aclk);wdata=data;wstrb=4'hf;wvalid=1;
            accepted=0;
            for(cycles=0;cycles<20;cycles=cycles+1) begin
                @(posedge aclk);
                if(wready) begin accepted=1;break;end
            end
            if(!accepted) $fatal(1,"W timeout data=%h",data);
            @(negedge aclk);wvalid=0;
        end
    endtask
    task automatic await_b(input [1:0] expected);
        integer cycles;
        bit seen;
        begin
            seen=0;
            for(cycles=0;cycles<24;cycles=cycles+1) begin
                @(negedge aclk);
                if(bvalid) begin seen=1;break;end
            end
`ifdef ROUTED_CELL
            // Full-design optimization left constant RESP[0] at the parent
            // boundary, so the isolated routed child exposes it as undriven.
            if(!seen || bresp[1]!==expected[1]) $fatal(1,"B timeout/response expected=%h got=%h valid=%b",expected,bresp,bvalid);
`else
            if(!seen || bresp!==expected) $fatal(1,"B timeout/response expected=%h got=%h valid=%b",expected,bresp,bvalid);
`endif
            bready=1;
            @(negedge aclk);bready=0;
            checks=checks+1;
        end
    endtask
    task automatic write32(input [6:0] addr,input [31:0] data,input integer mode,input [1:0] expected);
        integer cycles;
        bit aw_done,w_done;
        begin
            case(mode)
                0:begin send_aw(addr);repeat(3) @(negedge aclk);send_w(data);end
                1:begin send_w(data);repeat(4) @(negedge aclk);send_aw(addr);end
                default:begin
                    @(negedge aclk);awaddr=addr;awvalid=1;wdata=data;wstrb=4'hf;wvalid=1;
                    aw_done=0;w_done=0;
                    for(cycles=0;cycles<20;cycles=cycles+1) begin
                        @(posedge aclk);
                        if(awvalid && awready) aw_done=1;
                        if(wvalid && wready) w_done=1;
                        @(negedge aclk);
                        if(aw_done) awvalid=0;
                        if(w_done) wvalid=0;
                        if(aw_done && w_done) break;
                    end
                    if(!aw_done || !w_done) $fatal(1,"parallel AW/W timeout");
                end
            endcase
            await_b(expected);
        end
    endtask
    task automatic read32(input [6:0] addr,input [31:0] expected);
        integer cycles;
        bit seen;
        begin
            @(negedge aclk);araddr=addr;arvalid=1;
            seen=0;
            for(cycles=0;cycles<20;cycles=cycles+1) begin
                @(posedge aclk);
                if(arready) begin seen=1;break;end
            end
            if(!seen) $fatal(1,"AR timeout addr=%h",addr);
            @(negedge aclk);arvalid=0;
            repeat(2) @(negedge aclk); // emulate a stalled MMIO consumer
            seen=0;
            for(cycles=0;cycles<24;cycles=cycles+1) begin
                @(negedge aclk);
                if(rvalid) begin seen=1;break;end
            end
`ifdef ROUTED_CELL
            if(!seen || rresp[1]!==0 || rdata!==expected)
`else
            if(!seen || rresp!==0 || rdata!==expected)
`endif
                $fatal(1,"R timeout/data addr=%h expected=%h actual=%h resp=%h valid=%b",
                       addr,expected,rdata,rresp,rvalid);
            rready=1;
            @(negedge aclk);rready=0;
            checks=checks+1;
        end
    endtask

    // Zynq-like master keeps RREADY asserted and issues a new AR immediately
    // after accepting the previous R beat. The hardware failure followed a
    // successful ID read by an unanswered STATUS read.
    task automatic stream_read(input [6:0] addr,input [31:0] expected);
        integer cycles;
        bit accepted, responded;
        begin
            @(negedge aclk);araddr=addr;arvalid=1;
            accepted=0;
            for(cycles=0;cycles<20;cycles=cycles+1) begin
                @(posedge aclk);
                if(arready) begin accepted=1;break;end
            end
            if(!accepted) $fatal(1,"stream AR timeout addr=%h",addr);
            @(negedge aclk);arvalid=0;
            responded=0;
            for(cycles=0;cycles<24;cycles=cycles+1) begin
                @(posedge aclk);
                if(rvalid) begin
`ifdef ROUTED_CELL
                    if(rresp[1]!==0 || rdata!==expected)
`else
                    if(rresp!==0 || rdata!==expected)
`endif
                        $fatal(1,"stream R data addr=%h expected=%h actual=%h resp=%b",addr,expected,rdata,rresp);
                    responded=1;break;
                end
            end
            if(!responded) $fatal(1,"stream R timeout addr=%h",addr);
            checks=checks+1;
        end
    endtask

    reg [31:0] shadow[0:5];
    integer i,j;
    reg [31:0] value;
    initial begin
        for(i=0;i<6;i=i+1) shadow[i]=0;
        repeat(6) @(negedge aclk);aresetn=1;
        repeat(8) @(negedge aclk);
        pclk_enable=0; // stopped video clock, pixel reset asserted
        @(negedge aclk);rready=1;
        for(j=0;j<1000;j=j+1) begin
            stream_read(7'h00,32'h4f534401);
            stream_read(7'h04,0);
        end
        @(negedge aclk);rready=0;
        read32(7'h00,32'h4f534401);
        read32(7'h04,0);
        for(i=0;i<6;i=i+1) begin
            write32(7'h10+4*i,32'h01020300+i,i%3,0);
            read32(7'h10+4*i,0); // publication is discarded under pixel reset
        end
        write32(7'h08,1,1,0);
        read32(7'h04,0);
        pclk_enable=1;presetn=1;
        repeat(12) @(negedge aclk);
        for(j=0;j<10;j=j+1) begin
            for(i=0;i<6;i=i+1) begin
                value=32'h12340000+(j<<8)+i;
                write32(7'h10+4*i,value,(i+j)%3,0);
                shadow[i]=value;
                read32(7'h10+4*i,shadow[i]);
            end
            if(j%2==0) begin
                @(negedge aclk);presetn=0;
                repeat(5) @(negedge aclk);
                read32(7'h00,32'h4f534401);
                read32(7'h04,0);
                for(i=0;i<6;i=i+1) begin
                    shadow[i]=0;
                    read32(7'h10+4*i,0);
                end
                @(negedge aclk);presetn=1;
                repeat(12) @(negedge aclk);
            end
        end
        write32(7'h08,1,2,0);
        read32(7'h04,1); // no frame boundary, commit must remain pending
        @(negedge aclk);presetn=0;
        repeat(5) @(negedge aclk);
        read32(7'h04,0);
        $display("TEST_PASS OSD_AXI_TRANSACTION_STRESS checks=%0d",checks);
        $finish;
    end
    initial begin #2000000;$fatal(1,"OSD_AXI_TRANSACTION_STRESS_WATCHDOG");end
endmodule
