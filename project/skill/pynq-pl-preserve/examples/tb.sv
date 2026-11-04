`timescale 1ns/1ps
module tb_counter_example;
    reg clk=0,resetn=0,enable=0;
    wire [7:0] count;
    integer cycle;
    always #5 clk=~clk;
    example_counter dut(.aclk(clk),.aresetn(resetn),.enable(enable),.count(count));
    initial begin
        repeat(4) @(negedge clk);
        resetn=1;
        for(cycle=0;cycle<600;cycle=cycle+1)begin
            @(negedge clk);
            enable=cycle%7!=0;
            if(cycle==250)resetn=0;
            if(cycle==254)resetn=1;
        end
        enable=0;
        repeat(4) @(negedge clk);
        $display("COUNTER_EXAMPLE_DONE count=%h",count);
        $finish;
    end
endmodule
