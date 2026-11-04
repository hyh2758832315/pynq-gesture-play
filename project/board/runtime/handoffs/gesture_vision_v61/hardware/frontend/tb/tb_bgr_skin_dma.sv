`timescale 1ns/1ps
module tb_bgr_skin_dma;
    `include "dma_sizes.svh"
    reg clk=0;always #5 clk=~clk;
    reg rst=0,vin=0,lin=0,rout=0;
    reg [31:0] din=0;
    reg [3:0] kin=15;
    wire rin,vout,lout;
    wire [31:0] dout;
    wire [3:0] kout;
    reg [39:0] requests[0:NI-1];
    reg [35:0] expected[0:NO-1];
    integer sent=0,checked=0,frames=0;
    reg active=0,accepted=0,held=0;
    reg [36:0] previous;
    reg [31:0] rng=32'h41052026;
    bgr_skin_dma dut(.aclk(clk),.aresetn(rst),.s_axis_tdata(din),.s_axis_tkeep(kin),
        .s_axis_tvalid(vin),.s_axis_tlast(lin),.s_axis_tready(rin),
        .m_axis_tdata(dout),.m_axis_tkeep(kout),.m_axis_tvalid(vout),
        .m_axis_tlast(lout),.m_axis_tready(rout));
    always @(posedge clk) begin
        if(!rst) held=0;
        else if(active) begin
            accepted=vin && rin;
            if(accepted) sent=sent+1;
            if(held && (!vout || {lout,kout,dout}!==previous)) $fatal(1,"DMA reply unstable under backpressure");
            held=vout && !rout;previous={lout,kout,dout};
            if(vout && rout) begin
                if(checked>=NO || {lout,dout}!==expected[checked][32:0] || kout!=15)
                    $fatal(1,"DMA mismatch word=%0d actual=%h expected=%h",checked,{lout,dout},expected[checked]);
                checked=checked+1;
                if(lout) frames=frames+1;
            end
        end
    end
    always @(negedge clk) if(active) begin
        rng={rng[30:0],rng[31]^rng[21]^rng[1]^rng[0]};
        rout=rng[2:0]!=0;
        if(!vin || accepted) begin
            vin=sent<NI && rng[5:3]!=0;
            if(sent<NI) begin din=requests[sent][31:0];kin=requests[sent][35:32];lin=requests[sent][36];end
        end
    end
    task send_reset_word(input [31:0] data);
        begin
            @(negedge clk);din=data;vin=1;
            @(posedge clk);while(!rin) @(posedge clk);
            @(negedge clk);vin=0;
        end
    endtask
    initial begin
        $readmemh("../golden/dma_input.hex",requests);
        $readmemh("../golden/dma_expected.hex",expected);
        repeat(3) @(negedge clk);rst=1;
        send_reset_word(32'h534b4e36);send_reset_word(32'h00010007);
        send_reset_word(32'd99);send_reset_word(32'hff141400);send_reset_word(32'hff46);
        send_reset_word(32'h000000ff);send_reset_word(32'h0000ff00);
        repeat(10) @(negedge clk);rst=0;
        repeat(3) @(negedge clk);
        if(vout) $fatal(1,"adapter reset failed");
        rst=1;active=1;
        wait(checked==NO);@(negedge clk);vin=0;rout=1;
        repeat(20) @(negedge clk);
        if(vout || sent!=NI || frames!=NF) $fatal(1,"missing or extra replies");
        $display("BGR_SKIN_DMA_PASS input_words=%0d output_words=%0d packets=%0d malformed/reset/backpressure=PASS",sent,checked,frames);
        $finish;
    end
    initial begin #70000000;$fatal(1,"watchdog sent=%0d checked=%0d state=%0d",sent,checked,dut.state);end
endmodule
